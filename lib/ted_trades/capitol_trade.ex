defmodule TedTrades.CapitolTrade do
  alias __MODULE__

  defstruct [
    :tx_id,
    :politician_id,
    :politician_state_id,
    :politician_chamber,
    :politician_dob,
    :politician_first_name,
    :politician_gender,
    :politician_last_name,
    :politician_nickname,
    :politician_party,
    :pub_date,
    :filing_date,
    :tx_date,
    :tx_type,
    :tx_type_extended,
    :has_capital_gains,
    :owner,
    :chamber,
    :price,
    :size,
    :size_range_high,
    :size_range_low,
    :value,
    :reporting_gap,
    :comment,
    :committees,
    :asset_type,
    :asset_ticker,
    :asset_instrument,
    :labels
  ]

  use ExConstructor

  def new(data) do
    %CapitolTrade{
      tx_id: data["_txId"],
      politician_id: data["_politicianId"],
      politician_state_id: data["politician"]["_stateId"],
      politician_chamber: data["politician"]["chamber"],
      politician_dob: data["politician"]["dob"],
      politician_first_name: data["politician"]["firstName"],
      politician_gender: data["politician"]["gender"],
      politician_last_name: data["politician"]["lastName"],
      politician_nickname: data["politician"]["nickname"],
      politician_party: data["politician"]["party"],
      pub_date: data["pubDate"] |> string_to_naive_datetime(),
      filing_date: data["filingDate"],
      tx_date: data["txDate"],
      tx_type: data["txType"],
      tx_type_extended: data["txTypeExtended"],
      has_capital_gains: data["hasCapitalGains"],
      owner: data["owner"],
      chamber: data["chamber"],
      price: data["price"],
      size: data["size"],
      size_range_high: data["sizeRangeHigh"],
      size_range_low: data["sizeRangeLow"],
      value: data["value"],
      reporting_gap: data["reportingGap"],
      comment: data["comment"],
      committees: data["committees"],
      asset_type: data["asset"]["assetType"],
      asset_ticker: data["asset"]["assetTicker"],
      asset_instrument: data["asset"]["instrument"],
      labels: data["labels"]
    }
  end

  defp string_to_naive_datetime(str) do
    [date_part, time_part] = String.split(str, "T")
    [year, month, day] = Enum.map(String.split(date_part, "-"), &String.to_integer/1)

    [hour, minute, second] =
      Enum.map(String.split(String.split(time_part, "Z") |> hd, ":"), &String.to_integer/1)

    {:ok, datetime} = NaiveDateTime.new(year, month, day, hour, minute, second)
    datetime
  end
end
