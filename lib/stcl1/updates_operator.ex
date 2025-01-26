defmodule Stcl1.UpdatesOperator do
  require Logger

  alias Stcl1.Settings
  alias Stcl1.Storage
  alias Stcl1.Storage.Interfaces.Questions
  alias Stcl1.Storage.Interfaces.QuestionsLog
  alias Stcl1.Storage.Interfaces.Users
  # alias Stcl1.Storage.Question
  alias Stcl1.Storage.Schemas.Question

  def handle_message(text, operator_chat_id) do
    bot_token = Settings.bot_token()
    handle_message(bot_token, operator_chat_id, text)
  end

  def handle_message(bot_token, operator_chat_id, "/set_lineup_big " <> text) do
    Storage.write_lineup(:big, text)
    send_to_operator_from_bot(bot_token, operator_chat_id, "Состав на БИГ установлен")
  end

  def handle_message(bot_token, operator_chat_id, "/set_lineup_tough " <> text) do
    Storage.write_lineup(:tough, text)
    send_to_operator_from_bot(bot_token, operator_chat_id, "Состав на ЖЕСТКИЙ установлен")
  end

  def handle_message(bot_token, operator_chat_id, "/set_lineup_women " <> text) do
    Storage.write_lineup(:women, text)
    send_to_operator_from_bot(bot_token, operator_chat_id, "Состав на ЖЕНСКИЙ установлен")
  end

  def handle_message(bot_token, operator_chat_id, "/ban " <> chat_id) do
    Users.upsert(%{chat_id: chat_id, state: "banned"})
    send_to_operator_from_bot(bot_token, operator_chat_id, "#{chat_id} забанен")
  end

  def handle_message(bot_token, operator_chat_id, "/unban " <> chat_id) do
    Users.upsert(%{chat_id: chat_id, state: "idle"})
    send_to_operator_from_bot(bot_token, operator_chat_id, "#{chat_id} разбанен")
  end

  def handle_message(bot_token, operator_chat_id, "/questions") do
    questions = Questions.wait_list()
    message = compose_questions_list(questions)
    send_to_operator_from_bot(bot_token, operator_chat_id, message)
  end

  def handle_message(bot_token, operator_chat_id, "/users_count") do
    users_count = Users.count()
    send_to_operator_from_bot(bot_token, operator_chat_id, "Количество пользователей бота: #{inspect users_count}")
  end

  # Stcl1.UpdatesOperator.handle_message("6115660671:AAH-TlDsnfBBmdagZT2LMMkzPAl6XqIpJbM", "/users_dates 2024-01-01")
  def handle_message(bot_token, operator_chat_id, "/users_dates " <> start_date) do
    message = compose_users_regs(start_date)
    send_to_operator_from_bot(bot_token, operator_chat_id, "Даты регистраций c #{start_date}:\n\n#{message}")
  end

  def handle_message(bot_token, operator_chat_id, "/subs_by_date " <> date) do
    message = compose_users_subs_by_date(date)
    send_to_operator_from_bot(bot_token, operator_chat_id, message)
  end

  # Stcl1.UpdatesOperator.handle_message("qwe", "/ads 2023-01-23T23:50:07 zdarova snup doc")
  def handle_message(bot_token, operator_chat_id, "/ads " <> datetime_and_text) do
    message =
      with [datetime_iso, text] <- String.split(datetime_and_text, " ", parts: 2),
          {:ok, send_datetime, _} <- DateTime.from_iso8601(datetime_iso <> "+03:00"),
          send_unix <- DateTime.to_unix(send_datetime) do
        id_ads = Storage.create_ads(send_unix, text)
        "Рекламное сообщение с id = #{id_ads} успешно создано"
      else
        _ -> "Неверный формат входных данных"
      end

    send_to_operator_from_bot(bot_token, operator_chat_id, message)
  end

  def handle_message(bot_token, operator_chat_id, "/delete_ads " <> id_ads) do
    Storage.delete_ads(id_ads)
    send_to_operator_from_bot(bot_token, operator_chat_id, "Рекламное сообщение с id = #{id_ads} удалено")
  end

  def handle_message(bot_token, operator_chat_id, text) do
    case String.split(text, ["/", " "], parts: 3) do
      ["", _] -> :hueta
      ["", chat_id, answer] -> send_answer(bot_token, operator_chat_id, chat_id, answer)
      _ -> :hueta
    end
  end

  def send_answer(bot_token, operator_chat_id, chat_id, answer) do
    case Questions.get(chat_id) do
      %Question{
        text: text,
        status: :wait,
        updated_at: updated_at
      } ->
        answer = compose_answer(text, answer)
        send_to_customer(bot_token, chat_id, answer)
        Questions.upsert(%{chat_id: chat_id, text: text, status: "done"})
        QuestionsLog.insert(%{question_text: text, answer_text: answer, chat_id: chat_id, question_dt: updated_at, answer_dt: DateTime.utc_now()})
        send_to_operator_from_bot(bot_token, operator_chat_id, "Ты умничка!")

      _ ->
        send_to_operator_from_bot(bot_token, operator_chat_id, "Что-то не так, возможно ты уже отвечал на этот вопрос")
    end
  end

  def send_to_operator_from_bot(bot_token, operator_chat_id, message) do
    Telegram.Api.request(bot_token, "sendMessage", chat_id: operator_chat_id, text: message, parse_mode: "Markdown")
  end

  def send_to_operator_from_user(bot_token, chat_id, text) do
    curr_time = Time.utc_now()
    acceptable_from_time = Settings.operator_time_from()
    acceptable_to_time = Settings.operator_time_to()

    if curr_time < acceptable_to_time and curr_time > acceptable_from_time do
      QuestionsLog.insert(%{question_text: text, answer_text: nil, chat_id: chat_id, question_dt: DateTime.utc_now(), answer_dt: nil})
      Questions.upsert(%{chat_id: chat_id, text: text, status: "wait"})
      Users.upsert(%{chat_id: chat_id, in_conversation_with_operator: true})
      message = compose_question(text, chat_id)

      Enum.each(Settings.operators(), fn operator ->
        Telegram.Api.request(bot_token, "sendMessage", chat_id: operator, text: message, parse_mode: "Markdown")
      end)

      :operator_back
    else
      Questions.upsert(%{chat_id: chat_id, text: text, status: "out_of_working_hours"})
      :operator_back_later
    end
  end

  def send_to_customer(bot_token, chat_id, message) do
    Telegram.Api.request(bot_token, "sendMessage", chat_id: chat_id, text: message, parse_mode: "Markdown")
    Users.upsert(%{chat_id: chat_id, in_conversation_with_operator: false})
  end


  defp compose_users_regs(start_date_iso) do
    case NaiveDateTime.from_iso8601(start_date_iso <> "T00:00:00Z") do
      {:ok, start_naive_datetime} ->
        start_naive_datetime
        |> Users.select_from_date()
        |> Enum.map(fn %{inserted_at: inserted_at} ->
          inserted_at |> NaiveDateTime.to_date() |> Date.to_iso8601()
        end)
        |> Enum.join("\n")
      {:error, _error} ->
        "Неверный формат даты"
    end
  end

  defp compose_users_subs_by_date(date_iso) do
    with {:ok, naive_datetime_from} <- NaiveDateTime.from_iso8601(date_iso <> "T00:00:00Z"),
         naive_datetime_to <- NaiveDateTime.add(naive_datetime_from, 3600 * 24) do
      subs =
        naive_datetime_from
        |> Users.select_between_dates(naive_datetime_to)
        |> length()
      "Количество регистраций за #{date_iso}: #{subs}"
    else
      {:error, _} ->
        "Неверный формат даты"
    end
  end

  defp compose_questions_list([]), do: "Нет активных вопросов"
  defp compose_questions_list(questions) do
    questions
    |> Enum.map(fn question ->
      compose_question(question.text, question.chat_id)
    end)
    |> Enum.join("\n\n")
  end

  defp compose_question(question_text, chat_id),
    do: "/#{chat_id} #{question_text}"


  defp compose_answer(question_text, answer),
    do: "_#{question_text}_\n\n#{answer}"
end
