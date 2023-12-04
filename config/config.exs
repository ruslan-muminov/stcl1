import Config

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
