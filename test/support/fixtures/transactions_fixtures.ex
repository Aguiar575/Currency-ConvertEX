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
        conversionFee: 42,
        destinationCurrency: "some destinationCurrency",
        originCurrency: "some originCurrency",
        originCurrencyValue: 42,
        userId: 42
      })
      |> Currencyconversor.Transaction.create_transactions()

    transactions
  end
end
