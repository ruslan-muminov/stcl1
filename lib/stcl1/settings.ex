defmodule Stcl1.Settings do
  def bot_token do
    Application.get_env(:stcl1, :opts)[:bot_token]
  end

  def operator_time_from do
    Application.get_env(:stcl1, :operator)[:acceptable_utc_time][:from]
  end

  def operator_time_to do
    Application.get_env(:stcl1, :operator)[:acceptable_utc_time][:to]
  end

  def operator_chat_id do
    Application.get_env(:stcl1, :operator)[:chat_id]
  end
end
