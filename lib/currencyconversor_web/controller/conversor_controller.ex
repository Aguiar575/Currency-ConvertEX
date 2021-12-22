defmodule CurrencyconversorWeb.ConversorController do
  use CurrencyconversorWeb, :controller
  alias Currencyconversor.Conversor

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
    conn
    |> put_status(:ok)
    |> json(Conversor.convert_to(params["from"], params["to"], params["amount"]))
  end
end
