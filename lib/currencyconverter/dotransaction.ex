defmodule  Currencyconverter.Transaction.DoTransactions do
  require Logger
  alias Currencyconverter.Transaction.GetCurrencies
  @moduledoc """
    this module connects to the external currency conversion api (https://exchangeratesapi.io/documentation/).
  """

  @doc """
  converts the amount of a certain currency (from) to the selected currency (to).
  Returns a map with status :success or :error depending on the parameters of the conversion.

  ## Examples

      iex> convert_to("BRL", "EUR", "1")
      %{
        status: :success,
        transaction: %{
          amount: "1.00",
          converted: "0.16",
          currency_rate: "0.155594",
          from: "BRL",
          to: "EUR"
        }
      }
  """
  def convert_to(from, to, amount) do
    amount_f = amount |> String.replace(",", ".") |> Float.parse() |> elem(0)
    from = String.upcase(from)
    to = String.upcase(to)
    case GetCurrencies.get_conversion() do
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
      %HTTPoison.Response{status_code: 401, body: body} ->
        %{  status: :error,
            message: Jason.decode!(body)
          }
      %HTTPoison.Response{status_code: 404, body: _}  ->
        %{error: "Error 404: API endpoint not Found"}
      %HTTPoison.Response{status_code: _, body: body}  ->
        %{error: "Error while trying to get conection with API"}
        Logger.error("""
          Error while trying to get conection with API
          body: #{body}
          """)
      end
  end

  @doc """
  get the curency rate based on return of the external api.

  ## Examples
      iex> external_api_return = %{
      ...>           "base" => "EUR",
      ...>           "date" => "2021-12-22",
      ...>           "rates" => %{"BRL" => 6.422379, "JPY" => 129.338451, "USD" => 1.132496},
      ...>           "success" => true,
      ...>           "timestamp" => 1640199543
      ...>         }

      iex> get_currency_rate("BRL", "EUR", external_api_return)
      "0.155706"
  """
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

  @doc """
  converts the value of a origin currency (BRL, JPY, USD, EUR) to EUR.
  (origin value x currency rate)

  ## Examples
      iex> external_api_return = %{
      ...>           "base" => "EUR",
      ...>           "date" => "2021-12-22",
      ...>           "rates" => %{"BRL" => 6.422379, "JPY" => 129.338451, "USD" => 1.132496},
      ...>           "success" => true,
      ...>           "timestamp" => 1640199543
      ...>         }

      iex> get_converted_amount("BRL", "EUR", 5.0, external_api_return)
      0.78
  """
  def get_converted_amount(from, to, amount_f, conversion_body) do
    case from do
      "EUR" -> convert_to_euro(to, amount_f, conversion_body)
      "BRL" -> convert_value_from_euro(amount_f, conversion_body["rates"]["BRL"])
      "USD" -> convert_value_from_euro(amount_f, conversion_body["rates"]["USD"])
      "JPY" -> convert_value_from_euro(amount_f, conversion_body["rates"]["JPY"])
      _ -> %{error: "invalid currency"}
    end
  end

  @doc """
  converts the value of a EUR currency to another selected currency (BRL, JPY, USD, EUR).
  (EUR value x selected currency rate)

  ## Examples
      iex> external_api_return = %{
      ...>           "base" => "EUR",
      ...>           "date" => "2021-12-22",
      ...>           "rates" => %{"BRL" => 6.422379, "JPY" => 129.338451, "USD" => 1.132496},
      ...>           "success" => true,
      ...>           "timestamp" => 1640199543
      ...>         }

      iex> convert_to_euro("BRL", 5.0, external_api_return)
      32.11
  """
  def convert_to_euro(to, amount_f, conversion_body) do
    case to do
      "BRL" -> convert_value_to_euro(amount_f, conversion_body["rates"]["BRL"])
      "USD" -> convert_value_to_euro(amount_f, conversion_body["rates"]["USD"])
      "JPY" -> convert_value_to_euro(amount_f, conversion_body["rates"]["JPY"])
      "EUR" -> amount_f
      _ -> %{error: "invalid currency"}
    end
  end

  defp convert_value_to_euro(amount_f, rate) do
    (amount_f * rate) |> Float.round(2)
  end

  defp convert_value_from_euro(amount_f, rate) do
    unit =  if rate == 1, do: 1, else: 1 / rate
    (amount_f * unit) |> Float.round(2)
  end
end
