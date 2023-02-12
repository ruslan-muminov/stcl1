defmodule Stcl1.Updates do
  require Logger

  alias Stcl1.{Messages, Storage}

  @q_addres "Какой адрес у Стендап Клуба?"
  @q_buy_ticket_on_event "Хочу купить билеты на месте. Это возможно?"
  @q_unrecieved_ticket "Приобрел билет, но мне он не пришел. Что делать?"
  @q_return_ticket "Хочу вернуть билет. Как это сделать?"
  @q_shows_list "Какие шоу идут в Стендап Клубе сегодня?"
  @q_who_big "Кто выступает на биг BigStandUp?"
  @q_show_duration "Сколько длится шоу?"
  @q_tables_hundred "Как выглядят столы 100 и 100.1 в большом зале?"
  @q_order_food_drink "Хочу заказать еду и напитки. Могу ли я это сделать?"
  @q_show_passport "Обязательно ли показывать паспорт?"
  @q_child_with_batya "Можно ли несовершеннолетнему с родителями?"
  @q_parking "Есть ли у вас парковка?"

  [[@q_addres], [@q_buy_ticket_on_event], [@q_unrecieved_ticket], [@q_return_ticket],
   [@q_shows_list], [@q_who_big], [@q_show_duration], [@q_tables_hundred],
   [@q_order_food_drink], [@q_show_passport], [@q_child_with_batya], [@q_parking]]

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

  # defp proc_update(bot_token, %{"message" => %{"chat" => %{"id" => chat_id}}}) do
  #   Telegram.Api.request(bot_token, "sendMessage", chat_id: chat_id, text: "Eto test")
  # end

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

  defp handle_message(bot_token, chat_id, "/start") do
    send_message(bot_token, chat_id, Messages.message(:first))
  end

  defp handle_message(bot_token, chat_id, @q_addres) do
    send_message(bot_token, chat_id, Messages.message(:q_addres))
  end

  defp handle_message(bot_token, chat_id, @q_buy_ticket_on_event) do
    send_message(bot_token, chat_id, Messages.message(:q_buy_ticket_on_event))
  end

  defp handle_message(bot_token, chat_id, @q_unrecieved_ticket) do
    send_message(bot_token, chat_id, Messages.message(:q_unrecieved_ticket))
  end

  defp handle_message(bot_token, chat_id, @q_return_ticket) do
    send_message(bot_token, chat_id, Messages.message(:q_return_ticket))
  end

  defp handle_message(bot_token, chat_id, @q_shows_list) do
    send_message(bot_token, chat_id, Messages.message(:q_shows_list))
  end

  defp handle_message(bot_token, chat_id, @q_who_big) do
    send_message(bot_token, chat_id, Messages.message(:q_who_big))
  end

  defp handle_message(bot_token, chat_id, @q_show_duration) do
    send_message(bot_token, chat_id, Messages.message(:q_show_duration))
  end

  defp handle_message(bot_token, chat_id, @q_tables_hundred) do
    send_message(bot_token, chat_id, Messages.message(:q_tables_hundred))
  end

  defp handle_message(bot_token, chat_id, @q_order_food_drink) do
    send_message(bot_token, chat_id, Messages.message(:q_order_food_drink))
  end

  defp handle_message(bot_token, chat_id, @q_show_passport) do
    send_message(bot_token, chat_id, Messages.message(:q_show_passport))
  end

  defp handle_message(bot_token, chat_id, @q_child_with_batya) do
    send_message(bot_token, chat_id, Messages.message(:q_child_with_batya))
  end

  defp handle_message(bot_token, chat_id, @q_parking) do
    send_message(bot_token, chat_id, Messages.message(:q_parking))
  end

  defp handle_message(bot_token, chat_id, _) do
    send_menu(bot_token, chat_id)
  end

  defp send_message(bot_token, chat_id, message) do
    Telegram.Api.request(bot_token, "sendMessage", chat_id: chat_id, text: message)
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
end
