defmodule Stcl1Web.TgBotController do
  use Stcl1Web, :controller
  require Logger

  def update(conn, params) do
    Logger.info("TGBOT: #{inspect params}")
    json conn, %{data: "ok"}
  end
end
