defmodule Meow.Repo do
  use Ecto.Repo,
    otp_app: :meow,
    adapter: Ecto.Adapters.Postgres
end
