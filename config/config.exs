import Config

config :stcl1, ecto_repos: [Stcl1.Repo]

config :stcl1, Stcl1.Repo,
  database: "stcl1_repo",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"

config :logger,
  backends: [:console, {LoggerFileBackend, :error_log}]

config :logger, :error_log,
  path: "log/error.log",
  level: :error

config :mnesia,
  dir: '.mnesia/#{Mix.env}/#{node()}'

if File.exists?("config/#{Mix.env()}.exs") do
  import_config("#{Mix.env()}.exs")
end
