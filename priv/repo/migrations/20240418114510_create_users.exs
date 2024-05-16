defmodule Stcl1.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :chat_id, :string, primary_key: true
      add :state, :string, null: false, default: "idle"
      add :in_conversation_with_operator, :boolean, null: false, default: false

      timestamps()
    end
  end
end
