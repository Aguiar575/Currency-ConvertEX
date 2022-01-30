defmodule Currencyconverter.GetCurrencies do
  def get_conversion() do
    HTTPoison.get!("http://api.exchangeratesapi.io/v1/latest?access_key=#{retun_key()}&base=EUR&symbols=BRL,USD,JPY")
  end

  defp retun_key(), do: Application.get_env(:currencyconverter, CurrencyconverterWeb.Endpoint)[:api_key]
end
