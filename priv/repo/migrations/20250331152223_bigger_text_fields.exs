defmodule Stcl1.Repo.Migrations.BiggerTextFields do
  use Ecto.Migration

  def change do
    alter table(:questions) do
      modify :text, :string, size: 1500
      modify :chat_id, :string, size: 30
    end

    alter table(:questions_log) do
      modify :question_text, :string, size: 1500
      modify :answer_text, :string, size: 500
      modify :chat_id, :string, size: 30
    end
  end
end
