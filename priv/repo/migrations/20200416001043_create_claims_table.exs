defmodule LbryCommentNotifier.Repo.Migrations.CreateClaimsTable do
  use Ecto.Migration

  def change do
    create table(:claims, primary_key: false) do
      add(:id, :string, primary_key: true, autogenerate: false)
      add(:name, :string, null: false)
      add(:published_at, :utc_datetime, null: false)
    end
  end
end
