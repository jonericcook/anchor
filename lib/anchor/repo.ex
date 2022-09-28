defmodule Anchor.Repo do
  use Ecto.Repo,
    otp_app: :anchor,
    adapter: Ecto.Adapters.Postgres
end
