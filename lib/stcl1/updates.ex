defmodule Stcl1.Updates do
  require Logger

  alias Stcl1.Storage

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
            proc_update(bot_token, update)
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

  defp proc_update(bot_token, %{"message" => %{"chat" => %{"id" => chat_id}}}) do
    Telegram.Api.request(bot_token, "sendMessage", chat_id: chat_id, text: "Eto test")
  end

  defp get_last_update_id do
    case Storage.read_option(:last_update_id) do
      nil -> 0
      value -> value
    end
  end
end
