defmodule Kanbanlive.Repo do
  use Ecto.Repo,
    otp_app: :kanbanlive,
    adapter: Ecto.Adapters.Postgres
end
