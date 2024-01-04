defmodule ClashOfClansFpl.Repo do
  use Ecto.Repo,
    otp_app: :clash_of_clans_fpl,
    adapter: Ecto.Adapters.Postgres
end
