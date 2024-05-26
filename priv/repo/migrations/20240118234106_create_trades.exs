defmodule TedTrades.Repo.Migrations.CreateTrades do
  use Ecto.Migration

  def change do
    create table(:trades) do
      add :tx_id, :bigint, primary_key: true
      add :politician_id, :string
      add :politician_state_id, :string
      add :politician_chamber, :string
      add :politician_dob, :string
      add :politician_first_name, :string
      add :politician_gender, :string
      add :politician_last_name, :string
      add :politician_nickname, :string
      add :politician_party, :string
      add :pub_date, :naive_datetime
      add :filing_date, :string
      add :tx_date, :string
      add :tx_type, :string
      add :tx_type_extended, :string
      add :has_capital_gains, :boolean
      add :owner, :string
      add :chamber, :string
      add :price, :decimal, precision: 10, scale: 2
      add :size, :integer
      add :size_range_high, :integer
      add :size_range_low, :integer
      add :value, :decimal, precision: 15, scale: 2
      add :reporting_gap, :integer
      add :comment, :text
      add :committees, {:array, :string}, default: []
      add :asset_type, :string
      add :asset_ticker, :string
      add :asset_instrument, :string
      add :labels, {:array, :string}, default: []

      timestamps()
    end

    create(unique_index(:trades, [:tx_id]))
    create(index(:trades, [:politician_id]))
    create(index(:trades, [:politician_state_id]))
    create(index(:trades, [:politician_chamber]))
    create(index(:trades, [:politician_party]))
    create(index(:trades, [:filing_date]))
    create(index(:trades, [:tx_date]))
    create(index(:trades, [:price]))
    create(index(:trades, [:size]))
    create(index(:trades, [:pub_date]))
    create(index(:trades, [:value]))
  end
end
