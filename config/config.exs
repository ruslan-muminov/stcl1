import Config

config :mnesia,
  dir: '.mnesia/#{Mix.env}/#{node()}'  

config :stcl1, Stcl1.Scheduler,
  jobs: [
    # Every second
    # {{:extended, "*/5"}, {Stcl1.Updates, :get_updates, []}}
  ]

config :secrex,
  # key_file: ".secret-key",
  files: ["config/secret.exs"]

if File.exists?("./config/secret.exs") do
  import_config "secret.exs"
end
