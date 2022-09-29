defmodule Anchor.TransactionsTest do
  use Anchor.DataCase

  alias Anchor.Transactions

  describe "transactions" do
    alias Anchor.Transactions.Transaction

    import Anchor.TransactionsFixtures

    @invalid_attrs %{quote_currency: nil, quote_currency_amount: nil, status: nil, type: nil}

    test "get_transaction/1 returns the transaction with given id" do
      transaction = transaction_fixture()
      assert Transactions.get_transaction(transaction.id) == transaction
    end

    test "create_transaction/1 with valid data creates a transaction" do
      valid_attrs = %{
        quote_currency: "EOS",
        quote_currency_amount: 120.5,
        status: "executed",
        type: "adjustment"
      }

      assert {:ok, %Transaction{} = transaction} = Transactions.create_transaction(valid_attrs)
      assert transaction.quote_currency == "EOS"
      assert transaction.quote_currency_amount == 120.5
      assert transaction.status == "executed"
      assert transaction.type == "adjustment"
    end

    test "create_transaction/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Transactions.create_transaction(@invalid_attrs)
    end

    test "delete_transaction/1 deletes the transaction" do
      transaction = transaction_fixture()
      assert {:ok, %Transaction{}} = Transactions.delete_transaction(transaction)
      assert is_nil(Transactions.get_transaction(transaction.id))
    end

    test "ss_quote_currency_entire_dataset/0 returns the min, max, avg of entire dataset" do
      %{
        quote_currency: "EOS",
        quote_currency_amount: 10.5,
        status: "executed",
        type: "adjustment"
      }
      |> Transactions.create_transaction()

      %{
        quote_currency: "EOS",
        quote_currency_amount: 100.7,
        status: "executed",
        type: "stock_buy"
      }
      |> Transactions.create_transaction()

      assert %{min: 10.5, max: 100.7, avg: 55.6} = Transactions.ss_quote_currency_entire_dataset()
    end

    test "ss_quote_currency_stock_buy/0 returns the min, max, avg where type is stock_buy" do
      %{
        quote_currency: "EOS",
        quote_currency_amount: 10.5,
        status: "executed",
        type: "adjustment"
      }
      |> Transactions.create_transaction()

      %{
        quote_currency: "EOS",
        quote_currency_amount: 10.5,
        status: "executed",
        type: "stock_buy"
      }
      |> Transactions.create_transaction()

      %{
        quote_currency: "EOS",
        quote_currency_amount: 100.7,
        status: "executed",
        type: "stock_buy"
      }
      |> Transactions.create_transaction()

      assert %{min: 10.5, max: 100.7, avg: 55.6} = Transactions.ss_quote_currency_stock_buy()
    end

    test "ss_quote_currency_each_type/0 returns the min, max, avg for each type" do
      %{
        quote_currency: "EOS",
        quote_currency_amount: 10.5,
        status: "executed",
        type: "adjustment"
      }
      |> Transactions.create_transaction()

      %{
        quote_currency: "EOS",
        quote_currency_amount: 100.7,
        status: "executed",
        type: "adjustment"
      }
      |> Transactions.create_transaction()

      %{
        quote_currency: "EOS",
        quote_currency_amount: 10.5,
        status: "executed",
        type: "stock_buy"
      }
      |> Transactions.create_transaction()

      %{
        quote_currency: "EOS",
        quote_currency_amount: 100.7,
        status: "executed",
        type: "stock_buy"
      }
      |> Transactions.create_transaction()

      assert [
               %{type: "stock_buy", min: 10.5, max: 100.7, avg: 55.6},
               %{type: "adjustment", min: 10.5, max: 100.7, avg: 55.6}
             ] = Transactions.ss_quote_currency_each_type()
    end

    test "ss_quote_currency_each_type_quote_currency_combo/0 returns the min, max, avg for each type and quote currency combo" do
      %{
        quote_currency: "EOS",
        quote_currency_amount: 10.5,
        status: "executed",
        type: "adjustment"
      }
      |> Transactions.create_transaction()

      %{
        quote_currency: "BTC",
        quote_currency_amount: 100.7,
        status: "executed",
        type: "adjustment"
      }
      |> Transactions.create_transaction()

      %{
        quote_currency: "EOS",
        quote_currency_amount: 10.5,
        status: "executed",
        type: "stock_buy"
      }
      |> Transactions.create_transaction()

      %{
        quote_currency: "BTC",
        quote_currency_amount: 100.7,
        status: "executed",
        type: "stock_buy"
      }
      |> Transactions.create_transaction()

      %{
        quote_currency: "BTC",
        quote_currency_amount: 10.5,
        status: "executed",
        type: "stock_buy"
      }
      |> Transactions.create_transaction()

      assert [
               %{avg: 100.7, max: 100.7, min: 100.7, type: "adjustment", quote_currency: "BTC"},
               %{avg: 10.5, max: 10.5, min: 10.5, type: "adjustment", quote_currency: "EOS"},
               %{avg: 55.6, max: 100.7, min: 10.5, quote_currency: "BTC", type: "stock_buy"},
               %{avg: 10.5, max: 10.5, min: 10.5, quote_currency: "EOS", type: "stock_buy"}
             ] = Transactions.ss_quote_currency_each_type_quote_currency_combo()
    end
  end
end
