defmodule  Currencyconversor.Conversor do

  def convert_to(from, to, amount) do
    amount_f = amount |> String.replace(",", ".") |> Float.parse() |> elem(0)
    from = String.upcase(from)
    to = String.upcase(to)
    case get_conversion() do
      %HTTPoison.Response{status_code: 200, body: body} ->
        converted = get_converted_amount(from, to , amount_f, Jason.decode!(body))
        %{
          status: :success,
          transaction: %{  from: from,
              to: to,
              amount: :erlang.float_to_binary(amount_f, decimals: 2),
              converted: :erlang.float_to_binary(converted, decimals: 2),
              currency_rate: get_currency_rate(from, to, Jason.decode!(body))
            }
          }
      %HTTPoison.Response{status_code: _, body: body} ->
        %{  status: :error,
            message: Jason.decode!(body)
          }
      _ -> %{error: "Error while trying to get conection with API"}
    end
  end

  def get_currency_rate(from, to, body) do
    cond do
      String.upcase(to) == "EUR" and String.upcase(from) != "EUR" ->
        1 / body["rates"][String.upcase(from)] |> :erlang.float_to_binary(decimals: 6)
      String.upcase(to) == "EUR" and String.upcase(from) == "EUR" ->
        1.00 |> :erlang.float_to_binary(decimals: 2)
      true ->
        body["rates"][String.upcase(to)] |> :erlang.float_to_binary(decimals: 6)
    end
  end

  defp retun_key(), do: Application.fetch_env!(:currencyconversor, :api_key)

  def get_conversion() do
    HTTPoison.get!("http://api.exchangeratesapi.io/v1/latest?access_key=#{retun_key()}&base=EUR&symbols=BRL,USD,JPY")
  end

  def get_converted_amount(from, to, amount_f, conversion_body) do
    case from do
      "EUR" -> convert_to_euro(to, amount_f, conversion_body)
      "BRL" -> convert_value_from_euro(amount_f, conversion_body["rates"]["BRL"])
      "USD" -> convert_value_from_euro(amount_f, conversion_body["rates"]["USD"])
      "JPY" -> convert_value_from_euro(amount_f, conversion_body["rates"]["JPY"])
    end
  end

  def convert_to_euro(to, amount_f, conversion_body) do
    case to do
      "BRL" -> convert_value_to_euro(amount_f, conversion_body["rates"]["BRL"])
      "USD" -> convert_value_to_euro(amount_f, conversion_body["rates"]["USD"])
      "JPY" -> convert_value_to_euro(amount_f, conversion_body["rates"]["JPY"])
      "EUR" -> amount_f
    end
  end

  defp convert_value_to_euro(amount_f, rate) when is_float(amount_f) do
    (amount_f * rate) |> Float.round(2)
  end

  defp convert_value_from_euro(amount_f, rate) when is_float(amount_f) do
    unit =  if rate == 1, do: 1, else: 1 / rate
    (amount_f * unit) |> Float.round(2)
  end
end
