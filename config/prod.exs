import Config

config :stcl1, Stcl1.Scheduler,
  jobs: [
    # Every 3 minutes
    {"*/3 * * * *", {Stcl1.Scheduler, :maybe_finish_conversation, []}},
    # Every 5 minutes
    {"*/5 * * * *", {Stcl1.Scheduler, :maybe_send_ads, []}}
    # # Every day in 9:01 utc
    # {"1 9 * * *", {Stcl1.Scheduler, :send_deferred_questions, []}}
  ]

config :stcl1, :operator_acceptable_utc_time,
  from: ~T[09:00:00],
  to: ~T[19:00:00]

config :secrex,
  # key_file: ".secret-key",
  files: ["config/secret.exs"]

if File.exists?("./config/secret.exs") do
  import_config "secret.exs"
end
