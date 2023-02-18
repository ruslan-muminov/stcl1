defmodule Stcl1.UpdatesOperator do
  require Logger

  alias Stcl1.Storage
  alias Stcl1.Storage.Question

  @operator_chat_id 981934374

  def handle_message(bot_token, "/questions") do
    questions =
      Memento.transaction! fn ->
        Memento.Query.select(Question, {:==, :status, :wait})
        # + sort
      end

    message = compose_questions_list(questions)
    send_to_operator(bot_token, message)
  end

  def handle_message(bot_token, text) do
    case String.split(text, ["/", " "], parts: 3) do
      ["", _] -> :hueta
      ["", chat_id_str, answer] -> send_answer(bot_token, chat_id_str, answer)
      _ -> :hueta
    end
  end

  def send_answer(bot_token, chat_id_str, answer) do
    chat_id = String.to_integer(chat_id_str)

    case Storage.read_question(chat_id) do
      {question_type, question, :wait} ->
        answer = compose_answer(question_type, question, answer)
        send_to_customer(bot_token, chat_id, answer)
        Storage.write_question(chat_id, {question_type, question, :done})
        send_to_operator(bot_token, "Ты умничка!")
      _ ->
        send_to_operator(bot_token, "Что-то не так, возможно ты уже отвечал на этот вопрос")
    end
  end

  def send_to_operator(bot_token, message) do
    Telegram.Api.request(bot_token, "sendMessage", chat_id: @operator_chat_id, text: message, parse_mode: "Markdown")
  end

  def send_to_customer(bot_token, chat_id, message) do
    Telegram.Api.request(bot_token, "sendMessage", chat_id: chat_id, text: message, parse_mode: "Markdown")
  end

  defp compose_questions_list([]), do: "Нет активных вопросов"
  defp compose_questions_list(questions) do
    questions
    |> Enum.map(fn question ->
      compose_question(question.question_type, question.question, question.chat_id)
    end)
    |> Enum.join("\n\n")
  end

  def compose_question(:big_who, question, chat_id),
    do: "/#{chat_id} Какое шоу интересует (Big): #{question}"

  def compose_question(_, question, chat_id),
    do: "/#{chat_id} #{question}"

  defp compose_answer(:big_who, question, answer),
    do: "_Какое шоу интересует? (#{question})_\n\n#{answer}"

  defp compose_answer(_, question, answer),
    do: "_#{question}_\n\n#{answer}"
end
