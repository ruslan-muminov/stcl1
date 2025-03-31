defmodule Stcl1.Repo.Migrations.UseText do
  use Ecto.Migration

  def change do
    alter table(:questions_log) do
      modify :question_text, :text
      modify :answer_text, :text
    end
  end
end
