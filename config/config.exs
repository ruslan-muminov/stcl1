import Config

config :stcl1, :plug_opts,
  scheme: :https,
  plug: Stcl1.Endpoint,
  options: [port: 8443,
            otp_app: :stcl1,
            keyfile: "priv/ssl/stcl1.key",
            certfile: "priv/ssl/stcl1.pem"]

# if File.exists?("./config/#{Mix.env()}.exs") do
#   import_config "#{Mix.env()}.exs"
# end

if File.exists?("./config/secret.exs") do
  import_config "secret.exs"
end
