defmodule Currencyconverter.ConverterTest do
  use Currencyconverter.DataCase
  alias Currencyconverter.Converter

  @body %{
    "base" => "EUR",
    "date" => "2021-12-22",
    "rates" => %{"BRL" => 6.422379, "JPY" => 129.338451, "USD" => 1.132496},
    "success" => true,
    "timestamp" => 1_640_199_543
  }

  describe "get_currency_rate" do
    test "should return 0.155706 - BRL to EUR" do
      assert Converter.get_currency_rate("BRL", "EUR", @body) == "0.155706"
    end

    test "should return  6.422379 - EUR to BRL" do
      assert Converter.get_currency_rate("EUR", "BRL", @body) == "6.422379"
    end

    test "should return  129.338451 - EUR to JPY" do
      assert Converter.get_currency_rate("EUR", "JPY", @body) == "129.338451"
    end

    test "should return  0.007732 - JPY to EUR" do
      assert Converter.get_currency_rate("JPY", "EUR", @body) == "0.007732"
    end

    test "should return  1.132496 - EUR to USD" do
      assert Converter.get_currency_rate("EUR", "USD", @body) == "1.132496"
    end

    test "should return  0.883005 - USD to EUR" do
      assert Converter.get_currency_rate("USD", "EUR", @body) == "0.883005"
    end

    test "should return  1.00 - EUR to EUR" do
      assert Converter.get_currency_rate("EUR", "EUR", @body) == "1.00"
    end
  end

  describe "get_converted_amount" do
    test "should return 12.84 - EUR to BRL" do
      assert Converter.get_converted_amount("EUR", "BRL", 2.0, @body) == 12.84
    end

    test "should return 129.34 - EUR to JPY" do
      assert Converter.get_converted_amount("EUR", "JPY", 1.0, @body) == 129.34
    end

    test "should return 3.4 - EUR to USD" do
      assert Converter.get_converted_amount("EUR", "USD", 3.0, @body) == 3.4
    end

    test "should return 3.00 - EUR to EUR" do
      assert Converter.get_converted_amount("EUR", "EUR", 3.0, @body) == 3.00
    end

    test "should return 19.27 - EUR to BRL" do
      assert Converter.get_converted_amount("EUR", "BRL", 3.0, @body) == 19.27
    end

    test "should return 517.35 - EUR to JPY" do
      assert Converter.get_converted_amount("EUR", "JPY", 4.0, @body) == 517.35
    end

    test "should return 4.53 - EUR to USD" do
      assert Converter.get_converted_amount("EUR", "USD", 4.0, @body) == 4.53
    end

    test "should return invalid currency - ZTR to USD" do
      assert Converter.get_converted_amount("ZTR", "USD", 4.0, @body) == %{
               error: "invalid currency"
             }
    end

    test "should return invalid currency - EUR to ZTR" do
      assert Converter.get_converted_amount("EUR", "ZTR", 4.0, @body) == %{
               error: "invalid currency"
             }
    end
  end
end
