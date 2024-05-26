defmodule TedTrades.Tasks.Run do
  use Mix.Task

  @shortdoc "Runs the project with environment variables sourced from .env"

  def run(_) do
    # Source the .env file
    System.cmd("source", [".env"])

    # Run your Elixir mix project
    Mix.Task.run("run", ["--no-halt"])
  end
end
