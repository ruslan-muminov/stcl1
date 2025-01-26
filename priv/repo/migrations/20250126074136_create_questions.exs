defmodule Stcl1.Repo.Migrations.CreateQuestions do
  use Ecto.Migration

  # status: "out_of_working_hours" | "wait" | "done"

  def change do
    create table(:questions, primary_key: false) do
      add :chat_id, :string, primary_key: true
      add :text, :string, null: false
      add :status, :string, null: false, default: "wait"

      timestamps()
    end
  end
end
