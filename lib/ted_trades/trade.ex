defmodule TedTrades.Trade do
  use Ecto.Schema

  schema "trades" do
    field(:tx_id, :integer)
    field(:politician_id, :string)
    field(:politician_state_id, :string)
    field(:politician_chamber, :string)
    field(:politician_dob, :string)
    field(:politician_first_name, :string)
    field(:politician_gender, :string)
    field(:politician_last_name, :string)
    field(:politician_nickname, :string)
    field(:politician_party, :string)
    field(:pub_date, :naive_datetime)
    field(:filing_date, :string)
    field(:tx_date, :string)
    field(:tx_type, :string)
    field(:tx_type_extended, :string)
    field(:has_capital_gains, :boolean)
    field(:owner, :string)
    field(:chamber, :string)
    field(:price, :decimal)
    field(:size, :integer)
    field(:size_range_high, :integer)
    field(:size_range_low, :integer)
    field(:value, :decimal)
    field(:reporting_gap, :integer)
    field(:comment, :string)
    field(:committees, {:array, :string}, default: [])
    field(:asset_type, :string)
    field(:asset_ticker, :string)
    field(:asset_instrument, :string)
    field(:labels, {:array, :string}, default: [])

    timestamps()
  end
end
