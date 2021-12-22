defmodule Currencyconversor.TransactionFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Currencyconversor.Transaction` context.
  """

  @doc """
  Generate a transactions.
  """
  def transactions_fixture(attrs \\ %{}) do
    {:ok, transactions} =
      attrs
      |> Enum.into(%{
        conversion_rate: 42,
        destination_currency: "some destination_currency",
        origin_currency: "some origin_currency",
        origin_currency_value: 42,
        user_id: 42
      })
      |> Currencyconversor.Transaction.create_transactions()

    transactions
  end
end
