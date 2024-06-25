defmodule Stcl1.Updates do
  require Logger

  alias Stcl1.ChatMenuButton
  alias Stcl1.Message.Handler
  alias Stcl1.Settings
  alias Stcl1.Storage
  alias Stcl1.Storage.Interfaces.Users
  alias Stcl1.Storage.Schemas.User

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
            handle_update(update)
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

  defp handle_update(update) do
    case parse_update(update) do
      {:ok, {chat_id_int, date, text}} ->
        with :continue <- skip_outdated_updates(date),
            chat_id <- to_string(chat_id_int),
            nil <- Users.get(chat_id),
            {:ok, user} <- Users.upsert(%{chat_id: chat_id}, [:state, :in_conversation_with_operator, :updated_at]),
            {:ok, true} <- ChatMenuButton.set(chat_id) do
          Handler.handle_message(user, text)
        else
          %User{} = user ->
            Handler.handle_message(user, text)
          :skip ->
            # пропускаем этот апдейт
            :ok
          error ->
            Logger.error("handle_update error: #{inspect error}")
        end
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
end
