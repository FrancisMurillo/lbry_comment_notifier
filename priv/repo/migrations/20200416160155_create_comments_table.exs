defmodule LbryCommentNotifier.Repo.Migrations.CreateCommentsTable do
  @moduledoc false

  use Ecto.Migration

  def change do
    create table(:comments, primary_key: false) do
      add(:id, :string, primary_key: true, autogenerate: false)
      add(:claim_id, references(:claims, column: :id, type: :string, null: false))
      add(:commenter_id, :string, null: false)
      add(:commenter_name, :string, null: false)
      add(:commenter_url, :string, null: false)
      add(:is_hidden, :boolean, null: false)
      add(:comment, :string, null: false)
      add(:is_read, :boolean, null: false)
      add(:read_at, :utc_datetime, null: true)
      add(:published_at, :utc_datetime, null: false)
    end
  end
end
