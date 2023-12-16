defmodule Stcl1.UpdatesOperator do
  require Logger

  alias Stcl1.Settings
  alias Stcl1.Storage
  alias Stcl1.Storage.Question

  def handle_message(bot_token, "/ban " <> chat_id_str) do
    {:ok, chat_id} = try_string_to_integer(chat_id_str)
    Storage.write_user_state_ext(chat_id, :banned)
    send_to_operator_from_bot(bot_token, "#{chat_id} забанен")
  end

  def handle_message(bot_token, "/unban " <> chat_id_str) do
    {:ok, chat_id} = try_string_to_integer(chat_id_str)
    Storage.write_user_state_ext(chat_id, :idle)
    send_to_operator_from_bot(bot_token, "#{chat_id} разбанен")
  end

  def handle_message(bot_token, "/questions") do
    questions =
      Memento.transaction! fn ->
        Memento.Query.select(Question, {:==, :status, :wait})
        # + sort
      end

    message = compose_questions_list(questions)
    send_to_operator_from_bot(bot_token, message)
  end

  def handle_message(bot_token, "/users_count") do
    users_count = Storage.users_ext_count()
    send_to_operator_from_bot(bot_token, "Количество пользователей бота: #{inspect users_count}")
  end

  def handle_message(bot_token, "/users_dates " <> start_date) do
    message = compose_users_regs(start_date)
    send_to_operator_from_bot(bot_token, "Даты регистраций c #{start_date}:\n\n#{message}")
  end

  # Stcl1.UpdatesOperator.handle_message("qwe", "/ads 2023-01-23T23:50:07 zdarova snup doc")
  def handle_message(bot_token, "/ads " <> datetime_and_text) do
    message =
      with [datetime_iso, text] <- String.split(datetime_and_text, " ", parts: 2),
          {:ok, send_datetime, _} <- DateTime.from_iso8601(datetime_iso <> "+03:00"),
          send_unix <- DateTime.to_unix(send_datetime) do
        id_ads = Storage.create_ads(send_unix, text)
        "Рекламное сообщение с id = #{id_ads} успешно создано"
      else
        _ -> "Неверный формат входных данных"
      end

      send_to_operator_from_bot(bot_token, message)
  end

  def handle_message(bot_token, "/delete_ads " <> id_ads) do
    Storage.delete_ads(id_ads)
    send_to_operator_from_bot(bot_token, "Рекламное сообщение с id = #{id_ads} удалено")
  end

  def handle_message(bot_token, text) do
    case String.split(text, ["/", " "], parts: 3) do
      ["", _] -> :hueta
      ["", chat_id_str, answer] -> send_answer(bot_token, chat_id_str, answer)
      _ -> :hueta
    end
  end

  def send_answer(bot_token, chat_id_str, answer) do
    with {:ok, chat_id} <- try_string_to_integer(chat_id_str),
         {question_type, question, :wait, question_dt} <- Storage.read_question(chat_id) do
      answer = compose_answer(question_type, question, answer)
      send_to_customer(bot_token, chat_id, answer)
      Storage.write_question(chat_id, {question_type, question, :done})
      Storage.write_question_log(chat_id, question, question_dt, answer)
      send_to_operator_from_bot(bot_token, "Ты умничка!")
    else
      {:error, :non_integer_string_to_integer} ->
        send_to_operator_from_bot(bot_token, "Кажется, неверный формат сообщения((")
      _ ->
        send_to_operator_from_bot(bot_token, "Что-то не так, возможно ты уже отвечал на этот вопрос")
    end
  end

  def send_to_operator_from_bot(bot_token, message) do
    Telegram.Api.request(bot_token, "sendMessage", chat_id: Settings.operator_chat_id(), text: message, parse_mode: "Markdown")
  end

  def send_to_operator_from_user(bot_token, chat_id, user_state, text) do
    curr_time = Time.utc_now()
    acceptable_from_time = Settings.operator_time_from()
    acceptable_to_time = Settings.operator_time_to()

    question_type =
      if user_state == :wait_who_big do
        :big_who
      else
        :other
      end

    if curr_time < acceptable_to_time and curr_time > acceptable_from_time do
      if question_type == :other do
        Storage.write_question_log(chat_id, text, nil, nil)
      end

      Storage.write_question(chat_id, {question_type, text, :wait})
      Storage.write_user_state_ext(chat_id, user_state)
      message = compose_question(question_type, text, chat_id)
      Telegram.Api.request(bot_token, "sendMessage", chat_id: Settings.operator_chat_id(), text: message, parse_mode: "Markdown")
      :operator_back
    else
      Storage.write_question(chat_id, {question_type, text, :out_of_working_hours})
      :operator_back_later
    end
  end

  def send_to_customer(bot_token, chat_id, message) do
    Telegram.Api.request(bot_token, "sendMessage", chat_id: chat_id, text: message, parse_mode: "Markdown")
    Storage.write_user_state_ext(chat_id, :idle)
  end


  defp try_string_to_integer(str) do
    try do
      {:ok, String.to_integer(str)}
    rescue
      _ ->
        Logger.error("Attempt to convert non integer string to integer: #{str}")
        {:error, :non_integer_string_to_integer}
    end
  end

  defp compose_users_regs(start_date_iso) do
    with {:ok, start_datetime, _} <- DateTime.from_iso8601(start_date_iso <> "T00:00:00Z"),
         start_unix <- DateTime.to_unix(start_datetime) do
      users_ext = Storage.users_ext_all()

      users_ext
      |> Enum.flat_map(fn user_ext ->
        if user_ext.dt_reg > start_unix do
          {:ok, datetime_reg} = DateTime.from_unix(user_ext.dt_reg)
          date_reg_iso = datetime_reg |> DateTime.to_date() |> Date.to_iso8601()
          [date_reg_iso]
        else
          []
        end
      end)
      |> Enum.sort()
      |> Enum.join("\n")
    else
      {:error, _} ->
        "Неверный формат даты"
    end
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
