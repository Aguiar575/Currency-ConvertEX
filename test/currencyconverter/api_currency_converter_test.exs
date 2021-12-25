defmodule Currencyconverter.ApiCurrencyConverterTest do
  use Currencyconverter.DataCase

  @api_key Application.get_env(:currencyconverter, CurrencyconverterWeb.Endpoint)[:api_key]
  @uri "http://api.exchangeratesapi.io/v1/latest?access_key=?&base=EUR&symbols=BRL,USD,JPY"

  describe "API key validation" do
    test "should return 401 code" do
      %HTTPoison.Response{status_code: status, body: _} =
      HTTPoison.get!(@uri)
      assert status == 401
    end

    test "should return 200 code" do
      %HTTPoison.Response{status_code: status, body: _} =
      HTTPoison.get!("http://api.exchangeratesapi.io/v1/latest?access_key=#{@api_key}&base=EUR&symbols=BRL,USD,JPY")
      assert status == 200
    end
  end

  describe "Check API URI integrity" do
    test "host should be api.exchangeratesapi.io" do
      uri_integrity = URI.parse(@uri)
      assert uri_integrity.host == "api.exchangeratesapi.io"
    end

    test "path should be /v1/latest" do
      uri_integrity = URI.parse(@uri)
      assert uri_integrity.path == "/v1/latest"
    end

    test "path scheme be http" do
      uri_integrity = URI.parse(@uri)
      assert uri_integrity.scheme == "http"
    end
  end
end
