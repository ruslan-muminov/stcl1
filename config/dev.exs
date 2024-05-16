import Config

config :stcl1, Stcl1.Scheduler,
  jobs: []

config :stcl1, :operator,
  chat_id: "6829333403",
  acceptable_utc_time: [from: ~T[09:00:00], to: ~T[19:00:00]]

config :secrex,
  # key_file: ".secret-key",
  files: ["config/secret_dev.exs"]

if File.exists?("./config/secret_dev.exs") do
  import_config "secret_dev.exs"
end
