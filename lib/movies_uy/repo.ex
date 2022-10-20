defmodule MoviesUy.Repo do
  use Ecto.Repo,
    otp_app: :movies_uy,
    adapter: Ecto.Adapters.Postgres
end
