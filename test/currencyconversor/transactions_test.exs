defmodule Currencyconversor.TransactionTest do
  use Currencyconversor.DataCase

  alias Currencyconversor.Transaction

  describe "transactions" do
    alias Currencyconversor.Transaction.Transactions

    import Currencyconversor.TransactionFixtures

    @invalid_attrs %{conversion_rate: nil, destination_currency: nil, origin_currency: nil, origin_currency_value: nil, user_id: nil}

    test "list_transactions/0 returns all transactions" do
      transactions = transactions_fixture()
      assert Transaction.list_transactions() == [transactions]
    end

    test "get_transactions!/1 returns the transactions with given id" do
      transactions = transactions_fixture()
      assert Transaction.get_transactions!(transactions.id) == transactions
    end

    test "create_transactions/1 with valid data creates a transactions" do
      valid_attrs = %{conversion_rate: "42", destination_currency: "some destination_currency", origin_currency: "some origin_currency", origin_currency_value: "42", user_id: "42"}

      assert {:ok, %Transactions{} = transactions} = Transaction.create_transactions(valid_attrs)
      assert transactions.conversion_rate == "42"
      assert transactions.destination_currency == "some destination_currency"
      assert transactions.origin_currency == "some origin_currency"
      assert transactions.origin_currency_value == "42"
      assert transactions.user_id == "42"
    end

    test "create_transactions/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Transaction.create_transactions(@invalid_attrs)
    end

    test "update_transactions/2 with valid data updates the transactions" do
      transactions = transactions_fixture()
      update_attrs = %{conversion_rate: "43", destination_currency: "some updated destination_currency", origin_currency: "some updated origin_currency", origin_currency_value: "43", user_id: "43"}

      assert {:ok, %Transactions{} = transactions} = Transaction.update_transactions(transactions, update_attrs)
      assert transactions.conversion_rate == "43"
      assert transactions.destination_currency == "some updated destination_currency"
      assert transactions.origin_currency == "some updated origin_currency"
      assert transactions.origin_currency_value == "43"
      assert transactions.user_id == "43"
    end

    test "update_transactions/2 with invalid data returns error changeset" do
      transactions = transactions_fixture()
      assert {:error, %Ecto.Changeset{}} = Transaction.update_transactions(transactions, @invalid_attrs)
      assert transactions == Transaction.get_transactions!(transactions.id)
    end

    test "delete_transactions/1 deletes the transactions" do
      transactions = transactions_fixture()
      assert {:ok, %Transactions{}} = Transaction.delete_transactions(transactions)
      assert_raise Ecto.NoResultsError, fn -> Transaction.get_transactions!(transactions.id) end
    end

    test "change_transactions/1 returns a transactions changeset" do
      transactions = transactions_fixture()
      assert %Ecto.Changeset{} = Transaction.change_transactions(transactions)
    end
  end
end
