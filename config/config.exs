import Config

config :mnesia,
  dir: '.mnesia/#{Mix.env}/#{node()}'

config :stcl1, Stcl1.Scheduler,
  jobs: [
    # Every 3 minutes
    {"*/3 * * * *", {Stcl1.Scheduler, :maybe_finish_conversation, []}}
  ]

config :secrex,
  # key_file: ".secret-key",
  files: ["config/secret.exs"]

if File.exists?("./config/secret.exs") do
  import_config "secret.exs"
end
