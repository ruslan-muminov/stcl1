defmodule Stcl1.Scheduler do
  use Quantum, otp_app: :stcl1

  alias Stcl1.{Messages, Settings, Storage, UpdatesOperator}

  def send_deferred_questions do
    bot_token = Settings.bot_token()
    deferred_questions = Storage.deferred_questions()

    Enum.each(deferred_questions, fn dq ->
      user_state =
        if dq.question_type == :big_who do
          :wait_who_big
        else
          :wait_for_answer
        end

      UpdatesOperator.send_to_operator_from_user(bot_token, dq.chat_id, user_state, dq.question)
    end)
  end

  def maybe_finish_conversation do
    current_dt = DateTime.utc_now() |> DateTime.to_unix()
    bot_token = Settings.bot_token()

    users =
      Memento.transaction! fn ->
        guards = [
          {:<, :dt, current_dt - 10 * 60},
          {:==, :state, :idle}
        ]
        Memento.Query.select(Storage.UserExt, guards)
      end

    Enum.map(users, fn user ->
      Telegram.Api.request(
        bot_token,
        "sendMessage",
        chat_id: user.chat_id, text: Messages.message(:finish), parse_mode: "Markdown"
      )

      Storage.write_user_state_ext(user.chat_id, :finished)
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
    do_send_ads(bot_token, sorted_ads_list)
  end

  defp do_send_ads(_bot_token, []), do: :ok
  defp do_send_ads(bot_token, [ads | _]) do
    users = Storage.users_ext_all()
    Storage.update_ads_status(ads.id, :done)

    Enum.map(users, fn user ->
      Telegram.Api.request(
        bot_token,
        "sendMessage",
        chat_id: user.chat_id, text: ads.text, parse_mode: "Markdown"
      )
    end)
  end
end
