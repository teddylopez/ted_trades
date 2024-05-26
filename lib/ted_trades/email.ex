defmodule TedTrades.Email do
  import Swoosh.Email

  def send_update_email(trades) do
    new()
    |> to({"Ted", "tedmlopez@gmail.com"})
    |> from({"ted_trades", "tedmlopez@gmail.com"})
    |> subject("New CapitolTrades transactions")
    |> html_body(email_content(trades))
    |> TedTrades.Mailer.deliver()
  end

  defp email_content(trades) do
    buys =
      for buy <- Enum.filter(trades, &(&1.tx_type == "buy")) do
        "<li>#{buy.asset_ticker}</li>"
      end

    sells =
      for sell <- Enum.filter(trades, &(&1.tx_type == "sell")) do
        IO.inspect(sell)
        "<li>#{sell.asset_ticker}</li>"
      end

    ~s"""
    <div style="color: green;">BUYS:</div>
    <ul>
      #{Enum.join(buys, "")}
    </ul>
    <div style="color: #c8102e;">SELLS:</div>
    <ul>
      #{Enum.join(sells, "")}
    </ul>
    <div>TRADES:</div>
    #{print_trades(trades)}
    """
  end

  defp print_trades(trades) do
    trades
    |> Enum.map(&generate_trade_html/1)
    |> Enum.join()
  end

  defp generate_trade_html(trade) do
    """
    <div>
      <ul>
        <li>
          #{abbrev_chamber(trade)} #{trade.politician_first_name} #{trade.politician_last_name}
          (#{abbrev_party(trade)}-#{String.upcase(trade.politician_state_id)})
        </li>
        <li>
          <span style="font-weight: bold; color: #{if trade.tx_type == "buy", do: "green", else: "#c8102e"}">
            #{String.upcase(trade.tx_type)} #{trade.asset_ticker}
          </span>
        </li>
        <li>
          <span>
            #{Number.Currency.number_to_currency(trade.value)}: #{trade.size} shares at $#{trade.price} each.
          </span>
        </li>
      </ul>
    </div>
    """
  end

  defp abbrev_party(%{politician_party: "democrat"}), do: "D"
  defp abbrev_party(%{politician_party: "republican"}), do: "R"

  defp abbrev_party(%{politician_party: party}) do
    String.upcase(party)
    |> String.split("", trim: true)
    |> List.first()
  end

  defp abbrev_chamber(%{politician_chamber: "senate"}), do: "Senator"
  defp abbrev_chamber(%{politician_chamber: "house"}), do: "Representative"
  defp abbrev_chamber(_), do: nil
end
