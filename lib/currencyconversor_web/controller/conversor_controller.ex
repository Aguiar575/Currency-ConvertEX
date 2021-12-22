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
    valid_attrs = %{  conversion_rate: "42",
                      destination_currency: "some destination_currency",
                      origin_currency: "some origin_currency",
                      origin_currency_value: "42",
                      user_id: "42"}
    {:ok, %Transactions{} = transactions} = Transaction.create_transactions(valid_attrs)
    conn
    |> put_status(:ok)
    |> json(%{
      transaction_id: transactions.id,
      user_id: transactions.user_id,
      origin_currency: transactions.origin_currency,
      origin_currency_value: transactions.origin_currency_value,
      destination_currency: transactions.destination_currency,
      destination_currency_value: conversion["converted"],
      conversion_rate: transactions.conversion_rate,
      date_time: transactions.inserted_at
    })
  end
end
