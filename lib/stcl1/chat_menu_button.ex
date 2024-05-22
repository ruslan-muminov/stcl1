defmodule Stcl1.ChatMenuButton do
  alias Stcl1.Settings

  def set(chat_id) do
    bot_token = Settings.bot_token()
    menu_button = %{text: "Билеты", type: "web_app", web_app: %{url: "https://iframeab-pre3886.intickets.ru/events?utm_source=club_telegram_bot&utm_medium=social&utm_campaign=club_telegram_bot&utm_content=glavnaya"}}
    Telegram.Api.request(bot_token, "setChatMenuButton", chat_id: chat_id, menu_button: {:json, menu_button})
  end
end
