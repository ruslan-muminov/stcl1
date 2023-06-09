import Config

config :logger,
  backends: [:console, {LoggerFileBackend, :error_log}]

config :logger, :error_log,
  path: "log/error.log",
  level: :error

config :mnesia,
  dir: '.mnesia/#{Mix.env}/#{node()}'

config :stcl1, Stcl1.Scheduler,
  jobs: [
    # Every 3 minutes
    {"*/3 * * * *", {Stcl1.Scheduler, :maybe_finish_conversation, []}},
    # Every 5 minutes
    {"*/5 * * * *", {Stcl1.Scheduler, :maybe_send_ads, []}}
  ]

config :secrex,
  # key_file: ".secret-key",
  files: ["config/secret.exs"]

if File.exists?("./config/secret.exs") do
  import_config "secret.exs"
end
