defmodule LbryCommentNotifier.Claim do
  @moduledoc false

  use Ecto.Schema

  alias Ecto.Changeset

  alias LbryCommentNotifier.Lbry.Claim

  @primary_key {:id, :string, autogenerate: false}
  schema "claims" do
    field(:name, :string)
    field(:published_at, :utc_datetime)
  end

  def changeset(
        entity,
        %Claim{
          claim_id: id,
          name: name,
          timestamp: published_at
        }
      ) do
    entity
    |> Changeset.change(%{
      id: id,
      name: name,
      published_at: published_at
    })
    |> Changeset.unique_constraint(:id)
  end
end
