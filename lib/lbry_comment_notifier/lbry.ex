defmodule LbryCommentNotifier.Lbry do
  @moduledoc false

  use Tesla

  alias Ecto.Changeset
  alias Tesla.Env

  plug(Tesla.Middleware.BaseUrl, url())
  plug(Tesla.Middleware.Logger)

  plug(Tesla.Middleware.Retry,
    delay: 500,
    max_retries: 3,
    max_delay: 4_000
  )

  plug(Tesla.Middleware.JSON)

  defmodule Account do
    @moduledoc false

    use Ecto.Schema

    alias Ecto.Changeset

    @fields [:id, :name, :is_default]

    @primary_key false
    embedded_schema do
      field(:id, :string)
      field(:name, :string)
      field(:is_default, :boolean)
    end

    def changeset(entity, attrs) do
      entity
      |> Changeset.cast(attrs, @fields)
      |> Changeset.validate_required(@fields)
    end
  end

  defmodule Claim do
    @moduledoc false

    use Ecto.Schema

    alias Ecto.Changeset

    @fields [:claim_id, :name, :timestamp]

    @primary_key false
    embedded_schema do
      field(:claim_id, :string)
      field(:name, :string)
      field(:timestamp, Timestamp)
    end

    def changeset(entity, attrs) do
      entity
      |> Changeset.cast(attrs, @fields)
      |> Changeset.validate_required(@fields)
    end
  end

  defmodule Comment do
    @moduledoc false

    use Ecto.Schema

    alias Ecto.Changeset

    @fields [
      :comment_id,
      :claim_id,
      :channel_id,
      :channel_name,
      :channel_url,
      :comment,
      :is_hidden,
      :timestamp
    ]

    @primary_key false
    embedded_schema do
      field(:comment_id, :string)
      field(:claim_id, :string)
      field(:channel_id, :string)
      field(:channel_name, :string)
      field(:channel_url, :string)
      field(:comment, :string)
      field(:is_hidden, :boolean)
      field(:timestamp, Timestamp)
    end

    def changeset(entity, attrs) do
      entity
      |> Changeset.cast(attrs, @fields)
      |> Changeset.validate_required(@fields)
    end
  end

  defmodule PaginatedAccounts do
    @moduledoc false

    use Ecto.Schema

    alias Ecto.Changeset

    @fields [:total_pages, :total_items]

    @primary_key false
    embedded_schema do
      embeds_many(:items, Account)
      field(:total_pages, :integer)
      field(:total_items, :integer)
    end

    def changeset(entity, item_module, attrs) do
      entity
      |> Changeset.cast(attrs, @fields)
      |> Changeset.validate_required(@fields)
      |> Changeset.cast_embed(:items, required: true)
    end
  end

  defmodule PaginatedClaims do
    @moduledoc false

    use Ecto.Schema

    alias Ecto.Changeset

    @fields [:total_pages, :total_items]

    @primary_key false
    embedded_schema do
      embeds_many(:items, Claim)
      field(:total_pages, :integer)
      field(:total_items, :integer)
    end

    def changeset(entity, item_module, attrs) do
      entity
      |> Changeset.cast(attrs, @fields)
      |> Changeset.validate_required(@fields)
      |> Changeset.cast_embed(:items, required: true)
    end
  end

  defmodule PaginatedComments do
    @moduledoc false

    use Ecto.Schema

    alias Ecto.Changeset

    @fields [:total_pages, :total_items]

    @primary_key false
    embedded_schema do
      embeds_many(:items, Comment)
      field(:total_pages, :integer)
      field(:total_items, :integer)
    end

    def changeset(entity, item_module, attrs) do
      entity
      |> Changeset.cast(attrs, @fields)
      |> Changeset.validate_required(@fields)
      |> Changeset.cast_embed(:items, required: true)
    end
  end

  def paginated_accounts(base_page \\ nil, base_page_size \\ nil) do
    page = base_page || 1
    page_size = base_page_size || page_size()

    "/"
    |> post(%{method: "account_list", params: %{page: page, page_size: page_size}})
    |> parse_paginated(Account)
  end

  def paginated_claims_by_account_id(account_id, base_page \\ nil, base_page_size \\ nil) do
    page = base_page || 1
    page_size = base_page_size || page_size()

    "/"
    |> post(%{
      method: "claim_list",
      params: %{account_id: account_id, page: page, page_size: page_size}
    })
    |> parse_paginated(Claim)
  end


  def paginated_comments_by_claim_id(claim_id, base_page \\ nil, base_page_size \\ nil) do
    page = base_page || 1
    page_size = base_page_size || page_size()

    "/"
    |> post(%{
      method: "comment_list",
      params: %{claim_id: claim_id, page: page, page_size: page_size}
    })
    |> parse_paginated(Comment)
  end


  defp parse_paginated(response, item_module) do
    case response do
      {:ok, %Env{status: 200, body: %{"error" => %{} = error}}} ->
        {:error, :api_error, error}

      {:ok,
       %Env{
         status: 200,
         body: %{"result" => %{} = result}
       }} ->
        paginated_module =
          case item_module do
            Account -> PaginatedAccounts
            Claim -> PaginatedClaims
            Comment -> PaginatedComments
          end

        paginated_module
        |> struct(%{})
        |> paginated_module.changeset(item_module, result)
        |> case do
          %Changeset{valid?: true} = changeset ->
            {:ok, Changeset.apply_changes(changeset)}

          changeset ->
            {:error, :data_error, changeset}
        end

      {:error, error} ->
        {:error, :connection_error, error}
    end
  end

  defp page_size(),
    do: config()[:page_size] || 10

  defp url(),
    do: config()[:url] || "http://localhost:5279"

  defp config(),
    do: Application.get_env(:lbry_comment_notifier, __MODULE__) || []
end
