defmodule Currencyconversor.Tansactions.Transactions do
  use Ecto.Schema
  import Ecto.Changeset

  schema "transactions" do
    field :conversionFee, :integer
    field :destinationCurrency, :string
    field :originCurrency, :string
    field :originCurrencyValue, :integer
    field :userId, :integer

    timestamps()
  end

  @doc false
  def changeset(transactions, attrs) do
    transactions
    |> cast(attrs, [:userId, :originCurrency, :originCurrencyValue, :destinationCurrency, :conversionFee])
    |> validate_required([:userId, :originCurrency, :originCurrencyValue, :destinationCurrency, :conversionFee])
  end
end
