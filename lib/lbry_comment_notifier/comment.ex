defmodule LbryCommentNotifier.Comment do
  @moduledoc false

  use Ecto.Schema

  alias Ecto.Changeset

  alias LbryCommentNotifier.Claim

  alias LbryCommentNotifier.Lbry.Comment

  @primary_key {:id, :string, autogenerate: false}
  schema "comments" do
    field(:commenter_id, :string)
    field(:commenter_name, :string)
    field(:commenter_url, :string)
    field(:comment, :string)
    field(:hidden?, :boolean, source: :is_hidden)
    field(:read?, :boolean, source: :is_read)
    field(:read_at, :utc_datetime)
    field(:published_at, :utc_datetime)

    belongs_to(:claim, Claim,
      foreign_key: :claim_id,
      type: :string,
      on_replace: :nilify
    )
  end

  def changeset(
        entity,
        %Comment{
          comment_id: id,
          claim_id: claim_id,
          channel_id: commenter_id,
          channel_name: commenter_name,
          channel_url: commenter_url,
          is_hidden: hidden?,
          comment: comment,
          timestamp: published_at
        }
      ) do
    entity
    |> Changeset.change(%{
      id: id,
      claim_id: claim_id,
      commenter_id: commenter_id,
      commenter_name: commenter_name,
      commenter_url: commenter_url,
      hidden?: hidden?,
      comment: comment,
      published_at: published_at,
      read_at: nil,
      read?: false
    })
    |> Changeset.unique_constraint(:id)
  end

  def read_changeset(entity) do
    entity
    |> Changeset.change(%{
      read_at: DateTime.utc_now(),
      read?: true
    })
  end
end
