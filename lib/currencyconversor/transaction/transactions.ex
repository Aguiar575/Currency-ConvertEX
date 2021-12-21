defmodule Currencyconversor.Transaction.Transactions do
  use Ecto.Schema
  import Ecto.Changeset

  @required_params [:userId, :originCurrency, :originCurrencyValue, :destinationCurrency, :conversionFee]

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
    |> cast(attrs, @required_params)
    |> validate_required(@required_params)
  end
end
