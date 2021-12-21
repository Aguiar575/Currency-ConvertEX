defmodule Currencyconversor.TansactionsTest do
  use Currencyconversor.DataCase

  alias Currencyconversor.Tansactions

  describe "transactions" do
    alias Currencyconversor.Tansactions.Transactions

    import Currencyconversor.TansactionsFixtures

    @invalid_attrs %{conversionFee: nil, destinationCurrency: nil, originCurrency: nil, originCurrencyValue: nil, userId: nil}

    test "list_transactions/0 returns all transactions" do
      transactions = transactions_fixture()
      assert Tansactions.list_transactions() == [transactions]
    end

    test "get_transactions!/1 returns the transactions with given id" do
      transactions = transactions_fixture()
      assert Tansactions.get_transactions!(transactions.id) == transactions
    end

    test "create_transactions/1 with valid data creates a transactions" do
      valid_attrs = %{conversionFee: 42, destinationCurrency: "some destinationCurrency", originCurrency: "some originCurrency", originCurrencyValue: 42, userId: 42}

      assert {:ok, %Transactions{} = transactions} = Tansactions.create_transactions(valid_attrs)
      assert transactions.conversionFee == 42
      assert transactions.destinationCurrency == "some destinationCurrency"
      assert transactions.originCurrency == "some originCurrency"
      assert transactions.originCurrencyValue == 42
      assert transactions.userId == 42
    end

    test "create_transactions/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tansactions.create_transactions(@invalid_attrs)
    end

    test "update_transactions/2 with valid data updates the transactions" do
      transactions = transactions_fixture()
      update_attrs = %{conversionFee: 43, destinationCurrency: "some updated destinationCurrency", originCurrency: "some updated originCurrency", originCurrencyValue: 43, userId: 43}

      assert {:ok, %Transactions{} = transactions} = Tansactions.update_transactions(transactions, update_attrs)
      assert transactions.conversionFee == 43
      assert transactions.destinationCurrency == "some updated destinationCurrency"
      assert transactions.originCurrency == "some updated originCurrency"
      assert transactions.originCurrencyValue == 43
      assert transactions.userId == 43
    end

    test "update_transactions/2 with invalid data returns error changeset" do
      transactions = transactions_fixture()
      assert {:error, %Ecto.Changeset{}} = Tansactions.update_transactions(transactions, @invalid_attrs)
      assert transactions == Tansactions.get_transactions!(transactions.id)
    end

    test "delete_transactions/1 deletes the transactions" do
      transactions = transactions_fixture()
      assert {:ok, %Transactions{}} = Tansactions.delete_transactions(transactions)
      assert_raise Ecto.NoResultsError, fn -> Tansactions.get_transactions!(transactions.id) end
    end

    test "change_transactions/1 returns a transactions changeset" do
      transactions = transactions_fixture()
      assert %Ecto.Changeset{} = Tansactions.change_transactions(transactions)
    end
  end
end
