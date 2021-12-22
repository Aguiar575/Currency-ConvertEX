defmodule CurrencyconversorWeb.ConversorController do
  use CurrencyconversorWeb, :controller
  alias Currencyconversor.Conversor
  alias Currencyconversor.Transaction
  alias Currencyconversor.Transaction.Transactions

  def convert(conn, params) do
    cond do
      params["user_id"] in ["", nil] ->
        conn
        |> put_status(:bad_request)
        |> json(%{error: "'user_id' is required"})

      params["from"] in ["", nil] ->
        conn
        |> put_status(:bad_request)
        |> json(%{error: "'from' is required"})

        params["to"] in ["", nil] ->
        conn
        |> put_status(:bad_request)
        |> json(%{error: "'to' is required"})

      params["amount"] in ["", nil] ->
        conn
        |> put_status(:bad_request)
        |> json(%{error: "'amount' is required"})

      true -> convert_to(conn, params)

    end
  end

  defp convert_to(conn, params) do
    conversion = Conversor.convert_to(params["from"], params["to"], params["amount"])
    valid_attrs = %{  conversionFee: 42,
                      destinationCurrency: "some destinationCurrency",
                      originCurrency: "some originCurrency",
                      originCurrencyValue: 42,
                      userId: 42}
    {:ok, %Transactions{} = transactions} = Transaction.create_transactions(valid_attrs)
    conn
    |> put_status(:ok)
    |> json(%{
      transaction_id: transactions.id,
      user_id: transactions.userId,
      origin_currency: transactions.originCurrency,
      origin_currency_value: transactions.originCurrencyValue,
      destination_currency: transactions.destinationCurrency,
      destination_currency_value: conversion["converted"],
      conversion_rate: transactions.conversionFee,
      date_time: transactions.inserted_at
    })
  end
end
