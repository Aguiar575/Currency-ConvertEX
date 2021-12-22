defmodule  Currencyconversor.Conversor do

  @allow_currencies ["BRL","USD", "EUR", "JPY"]

  @spec convert_to(binary, binary, binary) :: %{error: <<_::128, _::_*96>>}
  def convert_to(from, to, amount) do
    amount = Integer.parse(amount) |> elem(0)
    cond do
      amount <= 0 or not is_number(amount) ->
        %{error: "Amount must be an number bigger than 0"}
      not is_valid_currency?(from) ->
        %{error: "Invalid currency: 'from'"}
      not is_valid_currency?(to) ->
        %{error: "Invalid currency: 'to'"}
      true ->
        handle_conversion(from, to, amount)
    end
  end

  @spec is_valid_currency?(binary) :: boolean
  defp is_valid_currency?(currency) do
    String.length(currency) == 3 and Enum.member?(@allow_currencies, String.upcase(currency))
  end

  @spec handle_conversion(binary, binary, number) :: any
  def handle_conversion(from, to, amount) do
    case get_conversion() do
      %HTTPoison.Response{status_code: 200, body: body} ->
        converted = get_converted_amount(from, to , amount, Jason.decode!(body))
        %{  "from" => from,
            "to" => to,
            "amount" => amount,
            "converted" => converted,
            "currency_rate" => Jason.decode!(body)["rates"][to]
          }
      %HTTPoison.Response{status_code: _, body: body} ->
        Jason.decode!(body)
      _ -> %{error: "Error while trying to get conection with API"}
    end
  end

  @spec retun_key :: nil | binary
  defp retun_key(), do: System.get_env("CURRENCY_API_KEY")

  def get_conversion() do
    HTTPoison.get!("http://api.exchangeratesapi.io/v1/latest?access_key=#{retun_key()}&base=EUR&symbols=BRL,USD,JPY")
  end

  @spec get_converted_amount(binary, binary, number, map) :: number | %{error: <<_::128, _::_*96>>}
  def get_converted_amount(from, to, amount, conversion_body) do
    case from do
      "EUR" -> convert_to_euro(to, amount, conversion_body)
      "BRL" -> convert_value_from_euro(amount, conversion_body["rates"]["BRL"])
      "USD" -> convert_value_from_euro(amount, conversion_body["rates"]["USD"])
      "JPY" -> convert_value_from_euro(amount, conversion_body["rates"]["JPY"])
      _ -> %{error: "Invalid currency"}
    end
  end

  @spec convert_to_euro(binary, number, map) :: number | %{error: <<_::128, _::_*96>>}
  def convert_to_euro(to, amount, conversion_body) do
    case to do
      "BRL" -> convert_value_to_euro(amount, conversion_body["rates"]["BRL"])
      "USD" -> convert_value_to_euro(amount, conversion_body["rates"]["USD"])
      "JPY" -> convert_value_to_euro(amount, conversion_body["rates"]["JPY"])
      "EUR" -> amount
      _ -> %{error: "Invalid currency"}
    end
  end

  defp convert_value_to_euro(amount, rate), do: (amount * rate) |> Float.round(2)
  defp convert_value_from_euro(amount, rate) do
    unit = 1 / rate
    (amount * unit) |> Float.round(2)
  end
end
