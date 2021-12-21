defmodule  Currencyconversor.Conversor do

  @allow_currencies ["BRL","USD", "EUR", "JPY"]

  @spec convert_to(binary, binary, number) :: %{error: <<_::128, _::_*96>>}
  def convert_to(from, to, amount) do
    cond do
      amount <= 0 or not is_number(amount) ->
        %{error: "Amount must be an number bigger than 0"}
      not is_valid_currency?(from) or not is_valid_currency?(to) ->
        %{error: "Invalid currency"}
      true ->
        body =
        get_conversion(to)
        |> get_conversion_body()
        |> IO.inspect()

        get_converted_amount(from, to , amount, body)
    end
  end

  @spec is_valid_currency?(binary) :: boolean
  defp is_valid_currency?(currency) do
    String.length(currency) == 3 and Enum.member?(@allow_currencies, String.upcase(currency))
  end

  @spec get_conversion_body(HTTPoison.Response.t()) :: any
  defp get_conversion_body(%HTTPoison.Response{status_code: 200, body: body}) do
    Jason.decode!(body)
  end

  defp get_conversion_body(%HTTPoison.Response{status_code: _, body: body}), do: body

  @spec retun_key :: nil | binary
  defp retun_key(), do: System.get_env("CURRENCY_API_KEY")

  @spec get_conversion(binary) :: any
  def get_conversion(symbol) when is_binary(symbol) do
    HTTPoison.get!("http://api.exchangeratesapi.io/v1/latest?access_key=#{retun_key()}&base=EUR&symbols=#{symbol}")
  end

  def get_conversion(symbol) when not is_binary(symbol) do
    %{error: "invalid symbol"}
  end

  @spec get_converted_amount(binary, binary, number, map) :: number | %{error: <<_::128, _::_*96>>}
  def get_converted_amount(from, to, amount, conversion_body) do
    case from do
      "EUR" -> convert_to_euro(to, amount, conversion_body)
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

  defp convert_value_to_euro(amount, rate), do: (amount * rate) |> Float.ceil(2)
  defp convert_value_from_euro(amount, rate), do: (amount / rate) |> Float.ceil(2)
end
