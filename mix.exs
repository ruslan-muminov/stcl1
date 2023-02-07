defmodule Stcl1.MixProject do
  use Mix.Project

  def project do
    [
      app: :stcl1,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :plug_cowboy],
      mod: {Stcl1.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:plug_cowboy, "~> 2.0"},
      # {:telegram, git: "https://github.com/visciang/telegram.git", tag: "0.20.1"},
      {:poison, "~> 3.1"}
    ]
  end
end
