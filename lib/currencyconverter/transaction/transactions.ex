defmodule Currencyconverter.Transaction.Transactions do
  use Ecto.Schema
  import Ecto.Changeset

  @required_params [
    :user_id,
    :origin_currency,
    :origin_currency_value,
    :destination_currency,
    :conversion_rate
  ]

  schema "transactions" do
    field(:conversion_rate, :string)
    field(:destination_currency, :string)
    field(:origin_currency, :string)
    field(:origin_currency_value, :string)
    field(:user_id, :integer)

    timestamps()
  end

  def changeset(transactions, attrs) do
    transactions
    |> cast(attrs, @required_params)
    |> validate_required(@required_params)
  end
end
