import Config

config :ted_trades, TedTrades.Repo,
  database: "ted_trades",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"

config :ted_trades, ecto_repos: [TedTrades.Repo]

config :ted_trades, TedTrades.Mailer,
  adapter: Swoosh.Adapters.Sendgrid,
  api_key: System.get_env("SENDGRID_API_KEY")

config :swoosh, serve_mailbox: true, preview_port: 4001
