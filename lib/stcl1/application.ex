defmodule Stcl1.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      Stcl1Web.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Stcl1.PubSub},
      # Start the Endpoint (http/https)
      Stcl1Web.Endpoint
      # Start a worker by calling: Stcl1.Worker.start_link(arg)
      # {Stcl1.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Stcl1.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    Stcl1Web.Endpoint.config_change(changed, removed)
    :ok
  end
end
