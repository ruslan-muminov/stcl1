defmodule Stcl1.Menu do
  alias Stcl1.Message.{Q, Text}
  alias Stcl1.Settings

  use Q

  def send_menu(user) do
    bot_token = Settings.bot_token()
    text = Text.text(:menu)
    keyboard = main_keyboard()
    keyboard_markup = %{one_time_keyboard: false, resize_keyboard: true, keyboard: keyboard}
    Telegram.Api.request(bot_token, "sendMessage", chat_id: user.chat_id, text: text, reply_markup: {:json, keyboard_markup})
  end

  defp main_keyboard do
    [[@q_lineup], [@q_shows_list], [@q_show_advice], [@q_show_date], [@q_tickets],
     [@q_loyalty_card], [@q_gift_cert], [@q_our_soc_networks], [@q_show_duration],
     [@q_order_food_drink], [@q_show_passport], [@q_child_with_batya], [@q_address], [@q_parking]]
  end
end
