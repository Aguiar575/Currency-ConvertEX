defmodule CurrencyconversorWeb.ConversorController do
  use CurrencyconversorWeb, :controller
  alias Currencyconversor.Conversor
  alias Currencyconversor.Transaction
  alias Currencyconversor.Transaction.Transactions

  @allow_currencies ["BRL","USD", "EUR", "JPY"]

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

      not is_valid_currency?(params["from"]) ->
        conn
        |> put_status(:bad_request)
        |> json(%{error: "Invalid currency: 'from'"})

        params["to"] in ["", nil] ->
        conn
        |> put_status(:bad_request)
        |> json(%{error: "'to' is required"})

      not is_valid_currency?(params["to"]) ->
        conn
        |> put_status(:bad_request)
        |> json(%{error: "Invalid currency: 'to'"})

      params["amount"] in ["", nil] ->
        conn
        |> put_status(:bad_request)
        |> json(%{error: "'amount' is required"})

      not is_amount_valid?(params["amount"]) ->
        conn
        |> put_status(:bad_request)
        |> json(%{error: "'amount' must be a number"})

      not amount_is_bigger_than_zero?(params["amount"]) ->
        conn
        |> put_status(:bad_request)
        |> json(%{error: "'amount' must be bigger than zero"})

      String.upcase(params["to"]) != "EUR" and String.upcase(params["from"]) != "EUR" ->
        conn
        |> put_status(:bad_request)
        |> json( %{error: "invalid currency conversion"})

      true -> handle_conversion(conn, params)

    end
  end

  @spec is_amount_valid?(binary) :: boolean
  def is_amount_valid?(amount) do
    case Float.parse(amount) do
      :error ->
        false
      _ ->
        true
    end
  end

  def is_valid_currency?(currency) do
    String.length(currency) == 3 and Enum.member?(@allow_currencies, String.upcase(currency))
  end

  def amount_is_bigger_than_zero?(amount) do
    Integer.parse(amount) |> elem(0) > 0
  end

  defp handle_conversion(conn, params) do
    conversion = Conversor.convert_to(params["from"], params["to"], params["amount"])
    case conversion do
      %{status: :success, transaction: _} ->
        conn
        |> return_conversion(conversion.transaction, params["user_id"])
      %{status: :error, message: _} ->
        conn
        |> put_status(:bad_request)
        |> json(conversion)
      _ ->
        conn
        |> json(conversion)
    end
  end

  defp return_conversion(conn, transaction, user_id) do
    transactions_map = %{ conversion_rate: transaction.currency_rate,
                          destination_currency: transaction.to,
                          origin_currency: transaction.from,
                          origin_currency_value: transaction.amount,
                          user_id: user_id
                        }
    IO.inspect(transactions_map)
    {:ok, %Transactions{} = transactions} = Transaction.create_transactions(transactions_map)
    conn
    |> put_status(:ok)
    |> json(%{
      transaction_id: transactions.id,
      user_id: transactions.user_id,
      origin_currency: transactions.origin_currency,
      origin_currency_value: transactions.origin_currency_value,
      destination_currency: transactions.destination_currency,
      destination_currency_value: transaction.converted,
      conversion_rate: transactions.conversion_rate,
      date_time: transactions.inserted_at
    })
  end
end
