defmodule Stcl1.Temp.ImportQuestions do
  alias Stcl1.Storage.Interfaces.Questions
  alias Stcl1.Storage.Question

  def run do
    questions =
      Memento.transaction! fn ->
        Memento.Query.select(Question, {:==, :question_type, :other})
      end

    Enum.each(questions, fn question ->
      attrs = %{
        chat_id: to_string(question.chat_id),
        text: to_string(question.question),
        status: to_string(question.status),
        inserted_at: question.dt |> DateTime.from_unix!() |> DateTime.to_naive(),
        updated_at: question.dt |> DateTime.from_unix!() |> DateTime.to_naive()
      }

      Questions.upsert(attrs)
    end)
  end
end
