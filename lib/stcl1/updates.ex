defmodule Stcl1.Updates do
  require Logger

  alias Stcl1.{Messages, Storage, UpdatesOperator}

  @operator_chat_id 981934374

  @q_addres "Какой адрес у Стендап Клуба?"
  @q_buy_ticket_on_event "Хочу купить билеты на месте. Это возможно?"
  @q_unrecieved_ticket "Приобрел билет, но мне он не пришел. Что делать?"
  @q_return_ticket "Хочу вернуть билет. Как это сделать?"
  @q_shows_list "Какие шоу идут в Стендап Клубе сегодня?"
  @q_who_big "Кто выступает на BigStandUp?"
  @q_show_duration "Сколько длится шоу?"
  @q_tables_hundred "Как выглядят столы 100 и 100.1 в большом зале?"
  @q_order_food_drink "Хочу заказать еду и напитки. Могу ли я это сделать?"
  @q_show_passport "Обязательно ли показывать паспорт?"
  @q_child_with_batya "Можно ли несовершеннолетнему с родителями?"
  @q_parking "Есть ли у вас парковка?"

  # Stcl1.Updates.start_long_polling()
  def start_long_polling do
    spawn_link(fn ->
      bot_token = Application.get_env(:stcl1, :opts)[:bot_token]
      do_long_poll(bot_token)
    end)
  end

  def do_long_poll(bot_token) do
    :ok = get_updates(bot_token)
    do_long_poll(bot_token)
  end

  # Stcl1.Updates.get_updates()
  def get_updates(bot_token) do
    last_update_id = get_last_update_id()

    case Telegram.Api.request(bot_token, "getUpdates", offset: last_update_id + 1, timeout: 30) do
      {:ok, updates} ->
        last_update_id =
          Enum.reduce(updates, :empty, fn update, _acc ->
            # Logger.info("Update: #{inspect update}")
            handle_update(bot_token, update)
            update["update_id"]
          end)

        if last_update_id != :empty, do:
          Storage.write_option(:last_update_id, last_update_id)

        :ok
      error ->
        Logger.error("Error during getUpdates request: #{inspect error}")
        :ok
    end
  end

  defp get_last_update_id do
    case Storage.read_option(:last_update_id) do
      nil -> 0
      value -> value
    end
  end

  defp handle_update(bot_token, update) do
    with {:ok, {chat_id, date, text}} <- parse_update(update),
         :continue <- skip_outdated_updates(date) do
      handle_message(bot_token, chat_id, text)
    else
      :skip ->
        # пропускаем этот апдейт
        :ok
      {:error, :parse_update_error} ->
        # прислали хуйню
        :ok
    end
  end

  defp parse_update(%{"message" => %{"chat" => %{"id" => chat_id}, "date" => date, "text" => text}}),
    do: {:ok, {chat_id, date, text}}
  defp parse_update(unmatched_update) do
    Logger.error("TelegramBot unmatched_update: #{inspect unmatched_update}")
    {:error, :parse_update_error}
  end

  defp skip_outdated_updates(date) do
    now = DateTime.utc_now() |> DateTime.to_unix()
    if now - date > 900 do
      :skip
    else
      :continue
    end
  end

  # extra commands for operator
  defp handle_message(bot_token, @operator_chat_id, text) do
    UpdatesOperator.handle_message(bot_token, text)
  end

  defp handle_message(bot_token, chat_id, "/start") do
    send_message(bot_token, chat_id, Messages.message(:first))
    update_user_state(chat_id, :idle)
  end

  defp handle_message(bot_token, chat_id, @q_addres) do
    send_message(bot_token, chat_id, Messages.message(:q_addres))
    update_user_state(chat_id, :idle)
  end

  defp handle_message(bot_token, chat_id, @q_buy_ticket_on_event) do
    send_message(bot_token, chat_id, Messages.message(:q_buy_ticket_on_event))
    update_user_state(chat_id, :idle)
  end

  defp handle_message(bot_token, chat_id, @q_unrecieved_ticket) do
    send_message(bot_token, chat_id, Messages.message(:q_unrecieved_ticket))
    update_user_state(chat_id, :idle)
  end

  defp handle_message(bot_token, chat_id, @q_return_ticket) do
    send_message(bot_token, chat_id, Messages.message(:q_return_ticket))
    update_user_state(chat_id, :idle)
  end

  defp handle_message(bot_token, chat_id, @q_shows_list) do
    send_message(bot_token, chat_id, Messages.message(:q_shows_list))
    update_user_state(chat_id, :idle)
  end

  defp handle_message(bot_token, chat_id, @q_who_big) do
    Telegram.Api.request(
      bot_token,
      "sendMessage",
      chat_id: chat_id, text: Messages.message(:q_who_big), parse_mode: "Markdown"
    )
    update_user_state(chat_id, :wait_who_big)
  end

  defp handle_message(bot_token, chat_id, @q_show_duration) do
    send_message(bot_token, chat_id, Messages.message(:q_show_duration))
    update_user_state(chat_id, :idle)
  end

  defp handle_message(bot_token, chat_id, @q_tables_hundred) do
    send_message(bot_token, chat_id, Messages.message(:q_tables_hundred))
    update_user_state(chat_id, :idle)
  end

  defp handle_message(bot_token, chat_id, @q_order_food_drink) do
    send_message(bot_token, chat_id, Messages.message(:q_order_food_drink))
    update_user_state(chat_id, :idle)
  end

  defp handle_message(bot_token, chat_id, @q_show_passport) do
    send_message(bot_token, chat_id, Messages.message(:q_show_passport))
    update_user_state(chat_id, :idle)
  end

  defp handle_message(bot_token, chat_id, @q_child_with_batya) do
    send_message(bot_token, chat_id, Messages.message(:q_child_with_batya))
    update_user_state(chat_id, :idle)
  end

  defp handle_message(bot_token, chat_id, @q_parking) do
    send_message(bot_token, chat_id, Messages.message(:q_parking))
    update_user_state(chat_id, :idle)
  end

  defp handle_message(bot_token, chat_id, text) do
    {user_state, _} = Storage.read_user_state(chat_id)

    question =
      if user_state == :wait_who_big do
        save_question(chat_id, text, :big_who)
      else
        Storage.write_question_log(chat_id, text)
        save_question(chat_id, text, :other)
      end

    send_message(bot_token, chat_id, Messages.message(:operator_back))
    UpdatesOperator.send_to_operator(bot_token, question)
    update_user_state(chat_id, :wait_for_answer)
  end

  def send_message(bot_token, chat_id, message) do
    Telegram.Api.request(bot_token, "sendMessage", chat_id: chat_id, text: message, parse_mode: "Markdown")
    send_menu(bot_token, chat_id)
  end

  defp send_menu(bot_token, chat_id) do
    message = Messages.message(:menu)
    keyboard = keyboard()
    keyboard_markup = %{one_time_keyboard: false, resize_keyboard: true, keyboard: keyboard}
    Telegram.Api.request(bot_token, "sendMessage", chat_id: chat_id, text: message, reply_markup: {:json, keyboard_markup})
  end

  defp keyboard do
    [[@q_addres], [@q_buy_ticket_on_event], [@q_unrecieved_ticket], [@q_return_ticket],
     [@q_shows_list], [@q_who_big], [@q_show_duration], [@q_tables_hundred],
     [@q_order_food_drink], [@q_show_passport], [@q_child_with_batya], [@q_parking]]
  end

  # Stcl1.Updates.save_question(70487131, "Здарова", :big_who)
  defp save_question(chat_id, text, question_type) do
    Storage.write_question(chat_id, {question_type, text, :wait})
    UpdatesOperator.compose_question(question_type, text, chat_id)
  end

  defp update_user_state(chat_id, state) do
    Storage.write_user(chat_id, state)
  end
end
