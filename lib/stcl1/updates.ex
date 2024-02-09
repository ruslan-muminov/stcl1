defmodule Stcl1.Updates do
  require Logger

  alias Stcl1.{Messages, Pictures, Settings, Storage, UpdatesOperator}

  @operator_chat_id Stcl1.Settings.operator_chat_id()

  @q_lineup "Актуальные составы на шоу"
  @q_lineup_big "BigStandUp"
  @q_lineup_tough "Жесткий стендап"
  @q_lineup_women "Женщины комики"

  @q_address "Какой адрес у Стендап Клуба?"
  @q_shows_list "Какие шоу идут в Стендап Клубе сегодня?"

  @q_show_advice "Посоветуйте, на какое шоу сходить"
  @q_show_advice_standup "Стендап"
  @q_show_advice_experiment "Комедийные эксперименты"
  @q_show_advice_panel "Пэнел шоу"
  @q_show_new_jokes "Новые шутки"
  @q_show_advice_something_else "Хочу посмотреть что-то еще"
  @q_show_advice_yes "Да"
  @q_show_advice_no "Нет"

  @q_show_date "На какое шоу пойти с девушкой/парнем?"

  @q_tickets "Покупка и возврат билетов"
  @q_buy_ticket_on_event "Хочу купить билеты на месте. Это возможно?"
  @q_unrecieved_ticket "Приобрел билет, но мне он не пришел. Что делать?"
  @q_return_ticket "Хочу вернуть билет. Как это сделать?"

  @q_loyalty_card "Карта лояльности"
  @q_gift_cert "Подарочный сертификат"
  @q_our_soc_networks "Наши социальные сети"

  @q_show_duration "Сколько длится шоу?"
  @q_order_food_drink "Хочу заказать еду и напитки. Могу ли я это сделать?"
  @q_show_passport "Обязательно ли показывать паспорт?"
  @q_child_with_batya "Можно ли несовершеннолетнему с родителями?"
  @q_parking "Есть ли у вас парковка?"

  @q_back "В главное меню"

  # Прокаженные
  @q_who_big "Кто выступает на BigStandUp?"
  @q_where_schedule "Где можно посмотреть расписание и составы на ближайшие шоу?"

  def child_spec(_arg) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, []}
    }
  end

  def start_link do
    {
      :ok,
      start_long_polling()
    }
  end

  # Stcl1.Updates.start_long_polling()
  def start_long_polling do
    spawn_link(fn ->
      bot_token = Settings.bot_token()
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
            Logger.info("Update: #{inspect update}")
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
      user_state =
        case Storage.read_user_ext_state(chat_id) do
          nil ->
            update_user_state(chat_id, :idle)
            :idle
          {state, _} ->
            state
        end
      handle_message(bot_token, chat_id, user_state, text)
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
  defp handle_message(bot_token, @operator_chat_id, _user_state, text) do
    UpdatesOperator.handle_message(bot_token, text)
  end

  defp handle_message(_bot_token, _chat_id, :banned, _text) do
    :dopizdelsya
  end

  defp handle_message(bot_token, chat_id, _user_state, "/start") do
    send_message(bot_token, chat_id, Messages.message(:first))
    reg_user(chat_id)
  end

  defp handle_message(bot_token, chat_id, _user_state, @q_back) do
    send_menu(bot_token, chat_id)
    update_user_state(chat_id, :idle)
  end

  defp handle_message(bot_token, chat_id, _user_state, @q_address) do
    send_message(bot_token, chat_id, Messages.message(:q_address))
    update_user_state(chat_id, :idle)
  end

  defp handle_message(bot_token, chat_id, _user_state, @q_shows_list) do
    send_message(bot_token, chat_id, Messages.message(:q_shows_list))
    update_user_state(chat_id, :idle)
  end

  ###################################################################
  # Покупка и возврат билетов
  #
  defp handle_message(bot_token, chat_id, _user_state, @q_tickets) do
    send_tickets_menu(bot_token, chat_id)
    update_user_state(chat_id, :tickets)
  end

  defp handle_message(bot_token, chat_id, :tickets, @q_buy_ticket_on_event) do
    send_message(bot_token, chat_id, Messages.message(:q_buy_ticket_on_event))
    update_user_state(chat_id, :idle)
  end

  defp handle_message(bot_token, chat_id, :tickets, @q_unrecieved_ticket) do
    send_message(bot_token, chat_id, Messages.message(:q_unrecieved_ticket))
    update_user_state(chat_id, :idle)
  end

  defp handle_message(bot_token, chat_id, :tickets, @q_return_ticket) do
    send_message(bot_token, chat_id, Messages.message(:q_return_ticket))
    update_user_state(chat_id, :idle)
  end
  #
  ###################################################################

  ###################################################################
  # Анкета: на какое шоу пойти
  #
  defp handle_message(bot_token, chat_id, _user_state, @q_show_advice) do
    variants = [[@q_show_advice_standup], [@q_show_advice_experiment],
                [@q_show_advice_panel], [@q_show_new_jokes], [@q_back]]
    message = Messages.message(:q_show_advice1)
    send_variants(bot_token, chat_id, variants, message)
    update_user_state(chat_id, :advice)
  end

  defp handle_message(bot_token, chat_id, :advice, @q_show_advice_standup) do
    send_album(bot_token, chat_id, Pictures.prepare_media(:group1))
    variants = [[@q_show_advice_something_else], [@q_back]]
    message = Messages.message(:q_show_advice_standup)
    send_variants(bot_token, chat_id, variants, message)
    update_user_state(chat_id, :advice)
  end

  defp handle_message(bot_token, chat_id, :advice, @q_show_advice_experiment) do
    send_album(bot_token, chat_id, Pictures.prepare_media(:group2))
    variants = [[@q_show_advice_something_else], [@q_back]]
    message = Messages.message(:q_show_advice_experiment)
    send_variants(bot_token, chat_id, variants, message)
    update_user_state(chat_id, :advice)
  end

  defp handle_message(bot_token, chat_id, :advice, @q_show_advice_panel) do
    send_album(bot_token, chat_id, Pictures.prepare_media(:group3))
    variants = [[@q_show_advice_something_else], [@q_back]]
    message = Messages.message(:q_show_advice_panel)
    send_variants(bot_token, chat_id, variants, message)
    update_user_state(chat_id, :advice)
  end

  defp handle_message(bot_token, chat_id, :advice, @q_show_new_jokes) do
    send_album(bot_token, chat_id, Pictures.prepare_media(:group6))
    variants = [[@q_show_advice_something_else], [@q_back]]
    message = Messages.message(:q_show_new_jokes)
    send_variants(bot_token, chat_id, variants, message)
    update_user_state(chat_id, :advice)
  end

  defp handle_message(bot_token, chat_id, :advice, @q_show_advice_something_else) do
    variants = [[@q_show_advice_yes], [@q_show_advice_no], [@q_back]]
    message = Messages.message(:q_show_advice2)
    send_variants(bot_token, chat_id, variants, message)
    update_user_state(chat_id, :advice)
  end

  defp handle_message(bot_token, chat_id, :advice, @q_show_advice_yes) do
    send_album(bot_token, chat_id, Pictures.prepare_media(:group4))
    variants = [[@q_back]]
    message = Messages.message(:q_show_advice_yes)
    send_variants(bot_token, chat_id, variants, message)
    update_user_state(chat_id, :advice)
  end

  defp handle_message(bot_token, chat_id, :advice, @q_show_advice_no) do
    send_album(bot_token, chat_id, Pictures.prepare_media(:group5))
    variants = [[@q_back]]
    message = Messages.message(:q_show_advice_no)
    send_variants(bot_token, chat_id, variants, message)
    update_user_state(chat_id, :advice)
  end
  #
  ###################################################################

  defp handle_message(bot_token, chat_id, _user_state, @q_show_date) do
    send_album(bot_token, chat_id, Pictures.prepare_media(:group7))
    send_message(bot_token, chat_id, Messages.message(:q_show_date))
    update_user_state(chat_id, :idle)
  end

  defp handle_message(bot_token, chat_id, _user_state, @q_who_big) do
    Telegram.Api.request(
      bot_token,
      "sendMessage",
      chat_id: chat_id, text: Messages.message(:q_who_big), parse_mode: "Markdown"
    )
    update_user_state(chat_id, :wait_who_big)
  end

  ###################################################################
  # Составы
  #
  defp handle_message(bot_token, chat_id, _user_state, @q_lineup) do
    variants = [[@q_lineup_big], [@q_lineup_tough], [@q_lineup_women]]
    message = Messages.message(:q_lineup)
    send_variants(bot_token, chat_id, variants, message)
    update_user_state(chat_id, :lineup)
  end

  defp handle_message(bot_token, chat_id, :lineup, @q_lineup_big) do
    message = Storage.read_lineup_text(:big)
    send_message(bot_token, chat_id, message)
    update_user_state(chat_id, :idle)
  end

  defp handle_message(bot_token, chat_id, :lineup, @q_lineup_tough) do
    message = Storage.read_lineup_text(:tough)
    send_message(bot_token, chat_id, message)
    update_user_state(chat_id, :idle)
  end

  defp handle_message(bot_token, chat_id, :lineup, @q_lineup_women) do
    message = Storage.read_lineup_text(:women)
    send_message(bot_token, chat_id, message)
    update_user_state(chat_id, :idle)
  end
  #
  ###################################################################

  defp handle_message(bot_token, chat_id, _user_state, @q_where_schedule) do
    send_message(bot_token, chat_id, Messages.message(:q_where_schedule))
    update_user_state(chat_id, :idle)
  end

  defp handle_message(bot_token, chat_id, _user_state, @q_show_duration) do
    send_message(bot_token, chat_id, Messages.message(:q_show_duration))
    update_user_state(chat_id, :idle)
  end

  defp handle_message(bot_token, chat_id, _user_state, @q_order_food_drink) do
    send_message(bot_token, chat_id, Messages.message(:q_order_food_drink))
    update_user_state(chat_id, :idle)
  end

  defp handle_message(bot_token, chat_id, _user_state, @q_show_passport) do
    send_message(bot_token, chat_id, Messages.message(:q_show_passport))
    update_user_state(chat_id, :idle)
  end

  defp handle_message(bot_token, chat_id, _user_state, @q_child_with_batya) do
    send_message(bot_token, chat_id, Messages.message(:q_child_with_batya))
    update_user_state(chat_id, :idle)
  end

  defp handle_message(bot_token, chat_id, _user_state, @q_parking) do
    send_message(bot_token, chat_id, Messages.message(:q_parking))
    update_user_state(chat_id, :idle)
  end

  defp handle_message(bot_token, chat_id, _user_state, @q_loyalty_card) do
    send_message(bot_token, chat_id, Messages.message(:q_loyalty_card))
    update_user_state(chat_id, :idle)
  end

  defp handle_message(bot_token, chat_id, _user_state, @q_our_soc_networks) do
    send_message(bot_token, chat_id, Messages.message(:q_our_soc_networks))
    update_user_state(chat_id, :idle)
  end

  defp handle_message(bot_token, chat_id, _user_state, @q_gift_cert) do
    send_album(bot_token, chat_id, Pictures.prepare_media(:group8))
    send_message(bot_token, chat_id, Messages.message(:q_gift_cert))
    update_user_state(chat_id, :idle)
  end

  # Custom message
  defp handle_message(bot_token, chat_id, user_state, text) do
    result = UpdatesOperator.send_to_operator_from_user(bot_token, chat_id, user_state, text)
    send_message(bot_token, chat_id, Messages.message(result))
  end

  def send_message(bot_token, chat_id, message) do
    Telegram.Api.request(bot_token, "sendMessage", chat_id: chat_id, text: message, parse_mode: "Markdown")
    send_menu(bot_token, chat_id)
  end

  defp send_menu(bot_token, chat_id) do
    message = Messages.message(:menu)
    keyboard = main_keyboard()
    keyboard_markup = %{one_time_keyboard: false, resize_keyboard: true, keyboard: keyboard}
    Telegram.Api.request(bot_token, "sendMessage", chat_id: chat_id, text: message, reply_markup: {:json, keyboard_markup})
  end

  defp main_keyboard do
    [[@q_lineup], [@q_address], [@q_shows_list], [@q_show_advice], [@q_show_date], [@q_tickets],
     [@q_loyalty_card], [@q_gift_cert], [@q_our_soc_networks], [@q_show_duration],
     [@q_order_food_drink], [@q_show_passport], [@q_child_with_batya], [@q_parking]]
  end

  defp send_tickets_menu(bot_token, chat_id) do
    message = @q_tickets
    keyboard = tickets_keyboard()
    keyboard_markup = %{one_time_keyboard: false, resize_keyboard: true, keyboard: keyboard}
    Telegram.Api.request(bot_token, "sendMessage", chat_id: chat_id, text: message, reply_markup: {:json, keyboard_markup})
  end

  defp tickets_keyboard do
    [[@q_buy_ticket_on_event], [@q_unrecieved_ticket], [@q_return_ticket], [@q_back]]
  end

  defp send_variants(bot_token, chat_id, variants, message) do
    keyboard_markup = %{one_time_keyboard: false, resize_keyboard: true, keyboard: variants}
    Telegram.Api.request(bot_token, "sendMessage", chat_id: chat_id, text: message, parse_mode: "Markdown", reply_markup: {:json, keyboard_markup})
  end

  defp send_album(bot_token, chat_id, media) do
    Telegram.Api.request(bot_token, "sendMediaGroup", chat_id: chat_id, media: media)
  end

  defp reg_user(chat_id) do
    Storage.reg_user_ext(chat_id)
  end

  defp update_user_state(chat_id, state) do
    Storage.write_user_state_ext(chat_id, state)
  end

  # Stcl1.Updates.test111()
  def test111 do
    chat_id = 70487131
    bot_token = Settings.bot_token()
    # Telegram.Api.request(bot_token, "sendPhoto", chat_id: chat_id, caption: "qweqeqwewqeqwe", parse_mode: "Markdown", photo: "AgACAgIAAxkBAAIVFWRaauo4reNadx_gHXkvDeWWu7z5AAKPyTEbwCzQStkmfqvUEoDCAQADAgADcwADLwQ")
    send_album(bot_token, chat_id, Pictures.prepare_media(:group6))
  end


  # Stcl1.Updates.test222("AgACAgIAAxkBAAMjZIM3m7GUPm_kBAQhX3yFKQiapFYAArrMMRv1ORhIxuA_5HIHUwoBAAMCAANzAAMvBA")
  def test222(photo) do
    chat_id = 70487131
    bot_token = Settings.bot_token()
    Telegram.Api.request(bot_token, "sendPhoto", chat_id: chat_id, caption: "qweqeqwewqeqwe", parse_mode: "Markdown", photo: photo)
  end
end
