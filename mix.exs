defmodule Stcl1.MixProject do
  use Mix.Project

  def project do
    [
      app: :stcl1,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      releases: [
        demo: [
          include_executables_for: [:unix],
          applications: [runtime_tools: :permanent]
        ]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Stcl1.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:plug_cowboy, "~> 2.0"},
      {:telegram, github: "visciang/telegram", tag: "0.22.4"},
      {:poison, "~> 3.1"},
      {:quantum, "~> 3.0"},
      {:memento, "~> 0.3.2"},
      {:secrex, "~> 0.3", runtime: false},
      {:uuid, "~> 1.1"}
    ]
  end
end
