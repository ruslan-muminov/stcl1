defmodule Stcl1.Storage.Interfaces.QuestionsLog do
  alias Stcl1.Repo
  alias Stcl1.Storage.Schemas.QuestionLog

  def insert(attrs) do
    %QuestionLog{}
    |> QuestionLog.changeset(attrs)
    |> Repo.insert()
  end
end
