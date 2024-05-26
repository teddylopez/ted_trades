defmodule TedTrades.Repo do
  use Ecto.Repo,
    otp_app: :ted_trades,
    adapter: Ecto.Adapters.Postgres
end
