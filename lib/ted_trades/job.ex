defmodule TedTrades.Job do
  use GenServer
  require Logger

  alias TedTrades.{CapitolTrade, Email, Repo, Trade}

  @base_url "bff.capitoltrades.com/trades?page=1&pageSize=50"

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def init(nil) do
    schedule_fetch()
    {:ok, nil}
  end

  defp schedule_fetch do
    # 20 minutes in milliseconds
    Process.send_after(self(), :fetch, 20 * 60 * 1000)

    # 10 seconds in milliseconds
    # Process.send_after(self(), :fetch, 10 * 1000)
  end

  def handle_info(:fetch, state) do
    fetch_data()
    schedule_fetch()
    {:noreply, state}
  end

  defp fetch_data do
    Logger.info("Fetching data from API at #{DateTime.utc_now()}")

    with {:ok, response} <- HTTPoison.get(@base_url, [], follow_redirect: true),
         {:ok, decoded_body} <- Poison.decode(response.body) do
      parse_response(decoded_body)
    else
      {:error, reason} ->
        handle_decode_error(reason)

      _ ->
        Logger.error("Failed to fetch data from API")
        {:error, "Failed to fetch data from API"}
    end
  end

  defp parse_response(response) do
    case response do
      %{"data" => data} when is_list(data) ->
        trades =
          Enum.map(data, &CapitolTrade.new/1)
          |> Enum.map(&Map.from_struct/1)
          |> Enum.map(&put_timestamps/1)
          |> remove_municipal_securities()

        existing_trades = Repo.all(Trade)

        {new_trades, _updated_trades} =
          Enum.reduce(trades, {[], []}, fn trade, {new_acc, updated_acc} ->
            case Enum.find(existing_trades, &(&1.tx_id == trade.tx_id)) do
              nil ->
                {[trade | new_acc], updated_acc}

              _existing_trade ->
                {new_acc, [trade | updated_acc]}
            end
          end)

        insert_txs(new_trades)
        log_details(new_trades)

        if Enum.any?(new_trades), do: Email.send_update_email(new_trades)

      _ ->
        Logger.warning("Unexpected response format: #{inspect(response)}")
        []
    end
  end

  defp put_timestamps(map) do
    map
    |> put_in([:inserted_at], NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second))
    |> put_in([:updated_at], NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second))
  end

  defp handle_decode_error(body) do
    Logger.error("Failed to decode JSON response: #{body}")
    {:error, :json_decode_failure}
  end

  defp log_details([]) do
    Logger.info("Trades table refreshed at: #{est_now()}")
    Logger.info("No new trades...")
  end

  defp log_details(new_trades) do
    Logger.info("Trades table refreshed at: #{est_now()}")

    case Enum.count(new_trades) do
      1 ->
        "1 new trade: #{inspect(Enum.map(new_trades, & &1.tx_id))}"

      num ->
        "#{num} new trades: #{inspect(Enum.map(new_trades, & &1.tx_id))}"
    end
    |> Logger.info()
  end

  defp insert_txs(trades) do
    Repo.insert_all(Trade, trades,
      on_conflict: :replace_all,
      conflict_target: :tx_id
    )
  end

  defp est_now() do
    date_time =
      NaiveDateTime.utc_now()
      |> DateTime.from_naive!("America/New_York")

    offsets = date_time.utc_offset + date_time.std_offset
    date_time |> DateTime.add(offsets)
  end

  defp remove_municipal_securities(trades) do
    trades
    |> Enum.filter(&(&1.asset_type != "municipal-security"))
  end
end
