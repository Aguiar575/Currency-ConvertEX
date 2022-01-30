defmodule CurrencyconverterWeb.ConverterView do
  use CurrencyconverterWeb, :view

  def render("show.json", %{transaction: transaction}) do
    IO.inspect(transaction)
    %{data: Enum.map(transaction, fn t -> %{ user_id: Enum.at(t, 0),
                                             origin_currency: Enum.at(t, 1),
                                             origin_currency_value: Enum.at(t, 2),
                                             destination_currency: Enum.at(t, 3),
                                             conversion_rate: Enum.at(t, 4),
                                             date: Enum.at(t, 5)
    } end) }
  end

  def render("convert.json", %{transaction: transaction, converted_value: converted_value}) do
    %{
      transaction_id: transaction.id,
      user_id: transaction.user_id,
      origin_currency: transaction.origin_currency,
      origin_currency_value: transaction.origin_currency_value,
      destination_currency: transaction.destination_currency,
      destination_currency_value: converted_value,
      conversion_rate: transaction.conversion_rate,
      date_time: transaction.inserted_at
    }
  end

  def render("error.json", %{error: error}) do
    %{error: error}
  end
end
