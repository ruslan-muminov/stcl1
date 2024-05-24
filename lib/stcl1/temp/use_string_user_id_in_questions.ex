defmodule Stcl1.Temp.UseStringUserIdInQuestions do
  alias Stcl1.Storage

  def run do
    questions =
      Memento.transaction! fn ->
        Memento.Query.all(Storage.Question)
      end

    Memento.transaction! fn ->
      Enum.each(questions, fn q ->
        if is_integer(q.chat_id) do
          q1 = Memento.Query.read(Storage.Question,to_string(q.chat_id))

          if q1 == nil do
            Memento.Query.write(
              %Storage.Question{chat_id: to_string(q.chat_id), question_type: q.question_type, question: q.question, status: q.status, dt: q.dt}
            )
          end

          Memento.Query.delete_record(q)
        end
      end)
    end
  end

  def all do
    Memento.transaction! fn ->
      Memento.Query.all(Storage.Question)
    end
  end
end
