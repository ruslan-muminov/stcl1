defmodule Stcl1.Repo.Migrations.CreateQuestionsLog do
  use Ecto.Migration

  def change do
    create table(:questions_log, primary_key: false) do
      add :id, :serial, primary_key: true
      add :question_text, :string
      add :answer_text, :string
      add :chat_id, :string
      add :question_dt, :utc_datetime
      add :answer_dt, :utc_datetime

      timestamps()
    end
  end
end
