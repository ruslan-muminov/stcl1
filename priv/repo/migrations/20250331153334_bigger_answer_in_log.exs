defmodule Stcl1.Repo.Migrations.BiggerAnswerInLog do
  use Ecto.Migration

  def change do
    alter table(:questions_log) do
      modify :answer_text, :string, size: 2000
    end
  end
end
