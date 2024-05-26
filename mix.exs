defmodule TedTrades.MixProject do
  use Mix.Project

  def project do
    [
      app: :ted_trades,
      version: "0.1.0",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {TedTrades.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ecto_sql, "~> 3.0"},
      {:postgrex, ">= 0.0.0"},
      {:exconstructor, "~> 1.2"},
      {:poison, "~> 5.0"},
      {:httpoison, "~> 2.2"},
      {:swoosh, "~> 1.15"},
      {:mail, ">= 0.0.0"},
      {:gen_smtp, "~> 1.0"},
      {:timex, "~> 3.7"},
      {:bandit, ">= 1.0.0"},
      {:plug_cowboy, ">= 1.0.0"},
      {:number, "~> 1.0"}
    ]
  end

  defp aliases do
    [
      r: ["run --no-halt", "run"]
    ]
  end
end
