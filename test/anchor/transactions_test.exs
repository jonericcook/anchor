defmodule Anchor.TransactionsTest do
  use Anchor.DataCase

  alias Anchor.Transactions

  describe "transactions" do
    alias Anchor.Transactions.Transaction

    import Anchor.TransactionsFixtures

    @invalid_attrs %{quote_currency: nil, quote_currency_amount: nil, status: nil, type: nil}

    test "list_transactions/0 returns all transactions" do
      transaction = transaction_fixture()
      assert Transactions.list_transactions() == [transaction]
    end

    test "get_transaction!/1 returns the transaction with given id" do
      transaction = transaction_fixture()
      assert Transactions.get_transaction!(transaction.id) == transaction
    end

    test "create_transaction/1 with valid data creates a transaction" do
      valid_attrs = %{quote_currency: "some quote_currency", quote_currency_amount: 120.5, status: "some status", type: "some type"}

      assert {:ok, %Transaction{} = transaction} = Transactions.create_transaction(valid_attrs)
      assert transaction.quote_currency == "some quote_currency"
      assert transaction.quote_currency_amount == 120.5
      assert transaction.status == "some status"
      assert transaction.type == "some type"
    end

    test "create_transaction/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Transactions.create_transaction(@invalid_attrs)
    end

    test "update_transaction/2 with valid data updates the transaction" do
      transaction = transaction_fixture()
      update_attrs = %{quote_currency: "some updated quote_currency", quote_currency_amount: 456.7, status: "some updated status", type: "some updated type"}

      assert {:ok, %Transaction{} = transaction} = Transactions.update_transaction(transaction, update_attrs)
      assert transaction.quote_currency == "some updated quote_currency"
      assert transaction.quote_currency_amount == 456.7
      assert transaction.status == "some updated status"
      assert transaction.type == "some updated type"
    end

    test "update_transaction/2 with invalid data returns error changeset" do
      transaction = transaction_fixture()
      assert {:error, %Ecto.Changeset{}} = Transactions.update_transaction(transaction, @invalid_attrs)
      assert transaction == Transactions.get_transaction!(transaction.id)
    end

    test "delete_transaction/1 deletes the transaction" do
      transaction = transaction_fixture()
      assert {:ok, %Transaction{}} = Transactions.delete_transaction(transaction)
      assert_raise Ecto.NoResultsError, fn -> Transactions.get_transaction!(transaction.id) end
    end

    test "change_transaction/1 returns a transaction changeset" do
      transaction = transaction_fixture()
      assert %Ecto.Changeset{} = Transactions.change_transaction(transaction)
    end
  end
end
