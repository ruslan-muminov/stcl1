defmodule Stcl1.Message.Sender do
  alias Stcl1.Menu
  alias Stcl1.Message.Q
  alias Stcl1.Message.Text
  alias Stcl1.Pictures
  alias Stcl1.Settings

  use Q

  def send_text_with_menu(user, text_atom) when is_atom(text_atom) do
    text = Text.text(text_atom)
    send_text_with_menu(user, text)
  end

  def send_text_with_menu(user, text) when is_binary(text) do
    bot_token = Settings.bot_token()
    Telegram.Api.request(bot_token, "sendMessage", chat_id: user.chat_id, text: text, parse_mode: "Markdown")
    Menu.send_menu(user)
  end

  def send_menu(user) do
    bot_token = Settings.bot_token()
    text = Text.text(:menu)
    keyboard = main_keyboard()
    keyboard_markup = %{one_time_keyboard: false, resize_keyboard: true, keyboard: keyboard}
    Telegram.Api.request(bot_token, "sendMessage", chat_id: user.chat_id, text: text, reply_markup: {:json, keyboard_markup})
  end

  def send_tickets_menu(user) do
    bot_token = Settings.bot_token()
    text = Text.text(:q_tickets_menu)
    keyboard = tickets_keyboard()
    keyboard_markup = %{one_time_keyboard: false, resize_keyboard: true, keyboard: keyboard}
    Telegram.Api.request(bot_token, "sendMessage", chat_id: user.chat_id, text: text, reply_markup: {:json, keyboard_markup})
  end

  def send_variants(user, variants, text_atom) when is_atom(text_atom) do
    text = Text.text(text_atom)
    send_variants(user, variants, text)
  end

  def send_variants(user, variants, text) when is_binary(text) do
    bot_token = Settings.bot_token()
    keyboard_markup = %{one_time_keyboard: false, resize_keyboard: true, keyboard: variants}
    Telegram.Api.request(bot_token, "sendMessage", chat_id: user.chat_id, text: text, parse_mode: "Markdown", reply_markup: {:json, keyboard_markup})
  end

  def send_album(user, media_atom) when is_atom(media_atom) do
    bot_token = Settings.bot_token()
    media = Pictures.prepare_media(media_atom)
    Telegram.Api.request(bot_token, "sendMediaGroup", chat_id: user.chat_id, media: media)
  end

  defp main_keyboard do
    [[@q_lineup], [@q_shows_list], [@q_show_advice], [@q_show_date], [@q_tickets],
     [@q_loyalty_card], [@q_gift_cert], [@q_our_soc_networks], [@q_show_duration],
     [@q_order_food_drink], [@q_show_passport], [@q_child_with_batya], [@q_address], [@q_parking]]
  end

  defp tickets_keyboard do
    [[@q_buy_ticket_on_event], [@q_unrecieved_ticket], [@q_return_ticket], [@q_back]]
  end
end
