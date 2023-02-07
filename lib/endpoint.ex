defmodule Stcl1.Endpoint do
  # alias Stcl1.MessageHandler

  use Plug.Router

  require Logger

  plug(Plug.Logger)
  plug(:match)
  plug(Plug.Parsers, parsers: [:json], json_decoder: Poison)
  plug(:dispatch)


  get "/ping" do
    send_resp(conn, 200, "pong!")
  end

  post "/tg_bot_webhook" do
    # MessageHandler.handle_message(conn)
    send_resp(conn, 200, "Ok")
  end

  match _ do
    send_resp(conn, 404, "ooops... Nothing there :(")
  end

  # def call_send_resp(conn) do
  #   send_resp(conn, 200, "")
  # end
end
