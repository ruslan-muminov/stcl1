defmodule Stcl1.Storage.Interfaces.Questions do
  import Ecto.Query

  alias Stcl1.Repo
  alias Stcl1.Storage.Schemas.Question

  def get(chat_id) when is_binary(chat_id) do
    Repo.get(Question, chat_id)
  end

  def wait_list() do
    Question
    |> where([q], q.status == "wait")
    |> order_by([q], q.updated_at)
    |> Repo.all()
  end

  def upsert(attrs) do
    %Question{}
    |> Question.changeset(attrs)
    |> Repo.insert(
      on_conflict: {:replace, [:text, :status, :updated_at]},
      conflict_target: :chat_id,
      returning: true
    )
  end
end
