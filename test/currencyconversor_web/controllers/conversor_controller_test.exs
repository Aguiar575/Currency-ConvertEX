defmodule CurrencyconverterWeb.ConverterControllerTest do
    use CurrencyconverterWeb.ConnCase
    alias CurrencyconverterWeb.ConverterController

    setup %{conn: conn} do
      {:ok, conn: put_req_header(conn, "accept", "application/json")}
    end

    describe "convert" do
      test "should return user_id error", %{conn: conn} do
        conn = post(conn, "/api/convert?from=usd&to=brl&amount=1")
        assert conn.resp_body == "{\"error\":\"'user_id' is required\"}"
      end

      test "should return user_id must be a number", %{conn: conn} do
        conn = post(conn, "/api/convert?user_id=dss&from=usd&to=brl&amount=1")
        assert conn.resp_body == "{\"error\":\"'user_id' must be a number\"}"
      end

      test "should return form is required", %{conn: conn} do
        conn = post(conn, "/api/convert?user_id=1&to=brl&amount=1")
        assert conn.resp_body == "{\"error\":\"'from' is required\"}"
      end

      test "should return form invalid currency", %{conn: conn} do
        conn = post(conn, "/api/convert?user_id=1&from=URU&to=brl&amount=1")
        assert conn.resp_body == "{\"error\":\"Invalid currency: 'from'\"}"
      end

      test "should return to is required", %{conn: conn} do
        conn = post(conn, "/api/convert?user_id=1&from=brl&amount=1")
        assert conn.resp_body == "{\"error\":\"'to' is required\"}"
      end

      test "should return to invalid currency", %{conn: conn} do
        conn = post(conn, "/api/convert?user_id=1&from=brl&to=oks&amount=1")
        assert conn.resp_body == "{\"error\":\"Invalid currency: 'to'\"}"
      end

      test "should return amount is required", %{conn: conn} do
        conn = post(conn, "/api/convert?user_id=1&to=EUR&from=BRL")
        assert conn.resp_body == "{\"error\":\"'amount' is required\"}"
      end

      test "should return amount must be a number", %{conn: conn} do
        conn = post(conn, "/api/convert?user_id=1&to=EUR&from=BRL&amount=HJJ")
        assert conn.resp_body == "{\"error\":\"'amount' must be a number\"}"
      end

      test "should return amount must be a number 2", %{conn: conn} do
        conn = post(conn, "/api/convert?user_id=1&to=EUR&from=BRL&amount=10HJJ")
        assert conn.resp_body == "{\"error\":\"'amount' must be a number\"}"
      end

      test "should return amount must be a bigger than 0", %{conn: conn} do
        conn = post(conn, "/api/convert?user_id=1&to=EUR&from=BRL&amount=0")
        assert conn.resp_body == "{\"error\":\"'amount' must be bigger than zero\"}"
      end

      test "should return invalid currency", %{conn: conn} do
        conn = post(conn, "/api/convert?user_id=1&to=BRL&from=BRL&amount=1")
        assert conn.resp_body == "{\"error\":\"invalid currency conversion\"}"
      end
    end

    describe "is_number_valid?" do
      test "should return true 1"  do
        return = ConverterController.is_number_valid?("1")
        assert return == true
      end

      test "should return true 2"  do
        return = ConverterController.is_number_valid?("1.1")
        assert return == true
      end

      test "should return false 1"  do
        return = ConverterController.is_number_valid?("asdas")
        assert return == false
      end

      test "should return false 2"  do
        return = ConverterController.is_number_valid?("10,asdas")
        assert return == false
      end
    end

    describe "is_valid_currency?" do
      test "should return true 1"  do
        return = ConverterController.is_valid_currency?("BRL")
        assert return == true
      end

      test "should return true 2"  do
        return = ConverterController.is_valid_currency?("JPY")
        assert return == true
      end

      test "should return true 3"  do
        return = ConverterController.is_valid_currency?("USD")
        assert return == true
      end

      test "should return true 4"  do
        return = ConverterController.is_valid_currency?("EUR")
        assert return == true
      end

      test "should return false 1"  do
        return = ConverterController.is_valid_currency?("JOI")
        assert return == false
      end

      test "should return false 2"  do
        return = ConverterController.is_valid_currency?("US")
        assert return == false
      end
    end

    describe "amount_is_bigger_than_zero?" do
      test "should return true"  do
        return = ConverterController.amount_is_bigger_than_zero?("1")
        assert return == true
      end

      test "should return false"  do
        return = ConverterController.amount_is_bigger_than_zero?("0")
        assert return == false
      end
    end
end
