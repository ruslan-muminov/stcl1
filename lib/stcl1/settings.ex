defmodule Stcl1.Settings do
  def bot_token do
    Application.get_env(:stcl1, :opts)[:bot_token]
  end

  def operator_time_from do
    Application.get_env(:stcl1, :operator_acceptable_utc_time)[:from]
  end

  def operator_time_to do
    Application.get_env(:stcl1, :operator_acceptable_utc_time)[:to]
  end
end
