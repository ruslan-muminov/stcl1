defmodule Stcl1.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  require Logger

  use Application

  def start(_type, _args) do
    children = [
      Plug.Cowboy.child_spec(
        Application.get_env(:stcl1, :plug_opts)
      )
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Stcl1.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
