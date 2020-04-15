defmodule LbryCommentNotifier.Jobs do
  @moduledoc false

  require Logger

  alias Flow

  alias LbryCommentNotifier.{Lbry, Comment, Claim, Repo, Emails, Mailer}

  def notify_new_comments() do
    Logger.info("Checking for new comments")

    new_comments = stream_comments()
    |> Flow.map(fn comment ->
      id = comment.comment_id

      comment_entity = Repo.get_by(Comment, id: id)

      cond do
        is_nil(comment_entity) ->
          Logger.info("Found new comment #{id}")

          %Comment{}
          |> Comment.changeset(comment)
          |> Repo.insert!()

        comment_entity.comment != comment.comment ->
          Logger.info("Updating edited #{id}")

          comment_entity
          |> Comment.changeset(comment)
          |> Repo.update!()

        true ->
          nil
      end
    end)
    |> Stream.reject(&is_nil/1)
    |> Stream.map(fn comment ->
      comment
      |> Emails.new_comment_email()
      |> Mailer.deliver_now()

      comment
      |> Comment.read_changeset()
      |> Repo.update!()
    end)
    |> Enum.to_list()

    Logger.info("Done checking for new comments")

    new_comments
  end

  defp stream_comments() do
    stream_accounts()
    |> Flow.from_enumerable()
    |> Flow.flat_map(fn account ->
      account.id
      |> stream_claims_by_account_id()
      |> Stream.map(&{account, &1})
    end)
    |> Flow.partition()
    |> Flow.flat_map(fn {account, claim} ->
      id = claim.claim_id

      claim_entity = Repo.get_by(Claim, id: id)

      cond do
        is_nil(claim_entity) ->
          Logger.info("Logging claim #{id}")

          %Claim{}
          |> Claim.changeset(claim)
          |> Repo.insert!()

        claim_entity.name != claim.name ->
          Logger.info("Updating edited claim #{id}")

          claim_entity
          |> Claim.changeset(claim)
          |> Repo.update!()

        true ->
          nil
      end

      claim.claim_id
      |> stream_comments_by_claim_id()
      |> Stream.map(fn comment ->
        comment
        |> Map.put(:account, account)
        |> Map.put(:claim, claim)
      end)
    end)
  end

  defp stream_accounts() do
    from_paginated(fn page ->
      Logger.info("Fetching accounts on page #{page}")

      page
      |> Lbry.paginated_accounts()
      |> case do
        {:error, _, _} = error ->
          Logger.error("Error in fetching accounts: #{inspect(error)}")

          error

        result ->
          result
      end
    end)
  end

  defp stream_claims_by_account_id(account_id) do
    from_paginated(fn page ->
      Logger.info("Fetching claims for #{account_id} on page #{page}")

      account_id
      |> Lbry.paginated_claims_by_account_id(page)
      |> case do
        {:error, _, _} = error ->
          Logger.error("Error in fetching claims: #{inspect(error)}")

          error

        result ->
          result
      end
    end)
  end

  defp stream_comments_by_claim_id(claim_id) do
    from_paginated(fn page ->
      Logger.info("Fetching comments for #{claim_id} on page #{page}")

      claim_id
      |> Lbry.paginated_comments_by_claim_id(page)
      |> case do
        {:error, _, _} = error ->
          Logger.error("Error in fetching comments: #{inspect(error)}")

          error

        result ->
          result
      end
    end)
  end

  defp from_paginated(paginated_fn) do
    Stream.resource(
      fn ->
        case paginated_fn.(1) do
          {:ok, %{total_pages: 0, items: items}} ->
            {:stop, items}

          {:ok, %{total_pages: 1, items: items}} ->
            {:stop, items}

          {:ok, %{items: items}} ->
            {:init, items}

          {:error, _, _} ->
            {:stop, []}
        end
      end,
      fn acc ->
        case acc do
          {:init, initial_items} ->
            {initial_items, {:cont, 2}}

          {:cont, current_page} ->
            case paginated_fn.(current_page) do
              {:ok, %{total_pages: total_pages, items: items}} when current_page >= total_pages ->
                {items, :stop}

              {:ok, %{items: items}} ->
                {items, {:cont, current_page + 1}}

              {:error, _, _} ->
                {:halt, nil}
            end

          {:stop, items} ->
            {items, :stop}

          :stop ->
            {:halt, nil}
        end
      end,
      fn _ -> :ok end
    )
  end
end
