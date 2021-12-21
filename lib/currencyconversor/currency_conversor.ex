defmodule  Currencyconversor.Conversor do

  @allow_symbols ["brl","usd", "eur", "jpy"]

  @spec retun_key :: nil | binary
  def retun_key(), do: System.get_env("CURRENCY_API_KEY")

  @spec get_currency_value(HTTPoison.Response.t()) :: any
  def get_currency_value(%HTTPoison.Response{status_code: 200, body: body}) do
    Jason.decode!(body)
  end

  def get_currency_value(%HTTPoison.Response{status_code: _, body: body}), do: body

  @spec get_currency_from(bitstring) :: any
  def get_currency_from(symbol) when is_bitstring(symbol) do
    HTTPoison.get!("http://api.exchangeratesapi.io/v1/latest?access_key=#{retun_key()}&base=EUR&symbols=#{symbol}")
    |> get_currency_value()
  end

  def get_currency_from(symbol) when not is_bitstring(symbol) do
    Jason.encode!(%{error: "invalid symbol"})
  end
end
