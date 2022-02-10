defmodule CurrencyconverterWeb.ConverterController do
  use CurrencyconverterWeb, :controller
  require Logger

  alias Currencyconverter.Convert

  alias Currencyconverter.Transaction
  alias Currencyconverter.Transaction.Transactions

  alias Currencyconverter.Conversion.Conversions
  alias Currencyconverter.Conversion.Errors

  @allow_currencies ["BRL","USD", "EUR", "JPY"]

  @spec show(Plug.Conn.t(), map) :: Plug.Conn.t()
  def show(conn, %{"id" => id}) do
    cond do
      id in ["", nil] ->
        conn
        |> put_status(:bad_request)
        |> render("error.json", error: "the user id is required")

      not is_number_valid?(id) ->
        conn
        |> put_status(:bad_request)
        |> render("error.json", error: "the user id must be a number")

      true ->
        transaction = Transaction.get_by_user_id!(id)
        conn
        |> put_status(:ok)
        |> render("show.json", transaction: transaction)
    end
  end

  def convert(conn, body) do
    params = %{user_id: body["user_id"], from: body["from"], to: body["to"], amount: body["amount"]}
    changeset = Conversions.changeset(params)
    do_convert(conn, changeset, changeset.valid?)
  end

  defp do_convert(conn, changeset, true) do
    handle_conversion(conn, changeset.changes)
  end

  defp do_convert(conn, changeset, false) do
    conn
    |> put_status(:bad_request)
    |> render("error.json", error: Errors.errors(changeset))
  end

  @spec is_number_valid?(binary) :: boolean
  def is_number_valid?(amount) do
    float = Float.parse(amount)
    cond do
      float == :error ->
        false
      float |> elem(1) != "" ->
        false
      true ->
        true
    end
  end

  def is_valid_currency?(currency) do
    String.length(currency) == 3 and Enum.member?(@allow_currencies, String.upcase(currency))
  end

  def amount_is_bigger_than_zero?(amount) do
    Integer.parse(amount) |> elem(0) > 0
  end

  def handle_conversion(conn, params) do
    conversion = Convert.convert_to(params.from, params.to, params.amount)
    case conversion do
      %{status: :success, transaction: _} ->
        conn
        |> return_conversion(conversion.transaction, params.user_id)
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
    transaction_map = %{ conversion_rate: transaction.currency_rate,
                          destination_currency: transaction.to,
                          origin_currency: transaction.from,
                          origin_currency_value: transaction.amount,
                          user_id: user_id
                        }
    case Transaction.create_transactions(transaction_map) do
      {:ok, %Transactions{} = transaction_db} ->
        conn
        |> put_status(:ok)
        |> render("convert.json", transaction: transaction_db, converted_value: transaction.converted)
      {:error, %Ecto.Changeset{} = changeset} ->
        Logger.error(changeset.errors)
        conn
        |> put_status(:bad_request)
        |> render("error.json", error: changeset.errors)
    end
  end
end
