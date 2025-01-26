defmodule Stcl1.Temp.ImportQuestionsLog do
  alias Stcl1.Storage.Interfaces.QuestionsLog
  alias Stcl1.Storage.QuestionLog

  def run do
    questions =
      Memento.transaction! fn ->
        Memento.Query.all(QuestionLog)
      end

    Enum.each(questions, fn question ->
      attrs =
        if is_nil(question.answer) do
          %{
            question_text: question.question,
            answer_text: nil,
            chat_id: question.chat_id,
            question_dt: question.dt |> DateTime.from_unix!() |> DateTime.to_naive(),
            answer_dt: nil
          }
        else
          %{
            question_text: question.question,
            answer_text: question.answer,
            chat_id: question.chat_id,
            question_dt: question.dt |> DateTime.from_unix!() |> DateTime.to_naive(),
            answer_dt: (question.dt + question.dt_diff) |> DateTime.from_unix!() |> DateTime.to_naive()
          }
        end

      QuestionsLog.insert(attrs)
    end)
  end
end
