defmodule Stcl1.Scheduler do
  use Quantum, otp_app: :stcl1

  alias Stcl1.Message.Text
  alias Stcl1.Settings
  alias Stcl1.Storage
  alias Stcl1.Storage.Interfaces.Users
  alias Stcl1.UpdatesOperator

  def send_deferred_questions do
    bot_token = Settings.bot_token()
    deferred_questions = Storage.deferred_questions()

    Enum.each(deferred_questions, fn dq ->
      UpdatesOperator.send_to_operator_from_user(bot_token, dq.chat_id, dq.question)
    end)
  end

  def maybe_finish_conversation do
    bot_token = Settings.bot_token()

    users = Users.select_finished()

    Enum.map(users, fn user ->
      Telegram.Api.request(
        bot_token,
        "sendMessage",
        chat_id: user.chat_id, text: Text.text(:finish), parse_mode: "Markdown"
      )

      Users.update_state(user, "finish")
    end)
  end

  def maybe_send_ads do
    bot_token = Settings.bot_token()
    current_dt = DateTime.utc_now() |> DateTime.to_unix()

    ads_list =
      Memento.transaction! fn ->
        guards = [
          {:<, :send_dt, current_dt},
          {:==, :status, :wait}
        ]
        Memento.Query.select(Storage.Ads, guards)
      end

    sorted_ads_list = Enum.sort(ads_list, &(&1.send_dt <= &2.send_dt))

    do_send_ads_by_chunks(bot_token, sorted_ads_list)
  end

  defp do_send_ads_by_chunks(_bot_token, []), do: :ok
  defp do_send_ads_by_chunks(bot_token, [ads | _]) do
    Storage.update_ads_status(ads.id, :done)

    Users.all()
    |> Enum.chunk_every(500)
    |> Enum.each(fn users_chunk ->
      do_send_ads(bot_token, ads, users_chunk)

      :timer.sleep(60000)
    end)
  end

  defp do_send_ads(bot_token, ads, users) do
    Task.start(fn ->
      Enum.each(users, fn user ->
        Telegram.Api.request(
          bot_token,
          "sendMessage",
          chat_id: user.chat_id, text: ads.text, parse_mode: "Markdown"
        )
      end)
    end)
  end
end
