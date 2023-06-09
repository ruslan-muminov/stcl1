defmodule Stcl1.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  require Logger

  use Application

  alias Stcl1.{Storage, Updates}

  def start(_type, _args) do
    Storage.init()

    children = [
      Stcl1.Scheduler
    ]

    Updates.start_long_polling()

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Stcl1.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
