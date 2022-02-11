defmodule CurrencyconverterWeb.UsersController do
  use CurrencyconverterWeb, :controller
  require Logger

  alias Currencyconverter.Transaction
  alias Currencyconverter.Conversion.Errors
  alias CurrencyConverter.User.Users

  @spec get_user(Plug.Conn.t(), map) :: Plug.Conn.t()
  def get_user(conn, body) do
    params = %{
      user_id: body["user_id"]
    }

    changeset = Users.changeset(params)
    find_user(conn, changeset, changeset.valid?)
  end

  defp find_user(conn, changeset, true) do
    transaction = Transaction.get_by_user_id!(changeset.changes.user_id)
    IO.inspect(transaction)

    conn
    |> put_status(:ok)
    |> render("show.json", transaction: transaction)
  end

  defp find_user(conn, changeset, false) do
    conn
    |> put_status(:bad_request)
    |> render("error.json", error: Errors.errors(changeset))
  end
end
