defmodule Stcl1.Scheduler do
  use Quantum, otp_app: :stcl1

  alias Stcl1.{Messages, Storage}

  def maybe_finish_conversation do
    current_dt = DateTime.utc_now() |> DateTime.to_unix()
    bot_token = Application.get_env(:stcl1, :opts)[:bot_token]

    users =
      Memento.transaction! fn ->
        guards = [
          {:<, :dt, current_dt - 10 * 60},
          {:==, :state, :idle}
        ]
        Memento.Query.select(Storage.User, guards)
      end

    Enum.map(users, fn user ->
      Telegram.Api.request(
        bot_token,
        "sendMessage",
        chat_id: user.chat_id, text: Messages.message(:finish), parse_mode: "Markdown"
      )

      Storage.write_user(user.chat_id, :finished)
    end)
  end
end
