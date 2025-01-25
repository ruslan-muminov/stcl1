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
      extra_applications: [:logger, :runtime_tools],
      mod: {Stcl1.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ecto, "~> 3.10"},
      {:ecto_sql, "~> 3.0"},
      {:postgrex, ">= 0.0.0"},
      {:plug_cowboy, "~> 2.0"},
      {:telegram, github: "visciang/telegram", tag: "2.0.0"},
      {:poison, "~> 3.1"},
      {:quantum, "~> 3.0"},
      {:memento, "~> 0.3.2"},
      {:secrex, "~> 0.3", runtime: false},
      {:uuid, "~> 1.1"},
      {:logger_file_backend, "~> 0.0.10"}
    ]
  end
end
