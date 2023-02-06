defmodule Stcl1.Repo do
  use Ecto.Repo,
    otp_app: :stcl1,
    adapter: Ecto.Adapters.Postgres
end
