defmodule AnchorWeb.TransactionControllerTest do
  use AnchorWeb.ConnCase

  import Anchor.TransactionsFixtures

  @create_attrs %{
    quote_currency: "EOS",
    quote_currency_amount: 120.5,
    status: "executed",
    type: "adjustment"
  }
  @invalid_attrs %{quote_currency: nil, quote_currency_amount: nil, status: nil, type: nil}

  setup %{conn: conn} do
    Anchor.Accounts.create_user(%{username: "hello", password: "there"})
    token = AnchorWeb.Token.generate_and_sign!(%{"username" => "hello", "password" => "there"})
    conn = conn
    |> put_req_header("accept", "application/json")
    |> put_req_header("authorization", "Bearer #{token}")

    {:ok, conn: conn}
  end

  describe "create transaction" do
    test "renders transaction when data is valid", %{conn: conn} do
      conn = post(conn, Routes.transaction_path(conn, :create), @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      assert %{
               "id" => ^id,
               "quote_currency" => "EOS",
               "quote_currency_amount" => 120.5,
               "status" => "executed",
               "type" => "adjustment"
             } = json_response(conn, 201)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.transaction_path(conn, :create), @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete transaction" do
    setup [:create_transaction]

    test "deletes chosen transaction", %{conn: conn, transaction: transaction} do
      conn = delete(conn, Routes.transaction_path(conn, :delete, transaction))
      assert response(conn, 204)
    end
  end

  describe "ss_quote_currency_amount" do
    test "gets min, max and avg of quote_currency_amount over entire dataset", %{conn: conn} do
      conn =
        post(conn, Routes.transaction_path(conn, :create), %{
          quote_currency: "EOS",
          quote_currency_amount: 10.5,
          status: "executed",
          type: "adjustment"
        })

      conn =
        post(conn, Routes.transaction_path(conn, :create), %{
          quote_currency: "EOS",
          quote_currency_amount: 100.7,
          status: "executed",
          type: "stock_buy"
        })

      conn =
        get(conn, Routes.transaction_path(conn, :ss_quote_currency_amount) <> "?entire_dataset")

      assert %{"min" => 10.5, "max" => 100.7, "avg" => 55.6} = json_response(conn, 200)
    end

    test "gets min, max and avg of quote_currency_amount for type of stock_buy", %{conn: conn} do
      conn =
        post(conn, Routes.transaction_path(conn, :create), %{
          quote_currency: "EOS",
          quote_currency_amount: 10.5,
          status: "executed",
          type: "stock_buy"
        })

      conn =
        post(conn, Routes.transaction_path(conn, :create), %{
          quote_currency: "EOS",
          quote_currency_amount: 100.7,
          status: "executed",
          type: "stock_buy"
        })

      conn =
        post(conn, Routes.transaction_path(conn, :create), %{
          quote_currency: "EOS",
          quote_currency_amount: 100.7,
          status: "executed",
          type: "adjustment"
        })

      conn = get(conn, Routes.transaction_path(conn, :ss_quote_currency_amount) <> "?stock_buy")

      assert %{"min" => 10.5, "max" => 100.7, "avg" => 55.6} = json_response(conn, 200)
    end

    test "gets min, max and avg of quote_currency_amount for each type", %{conn: conn} do
      conn =
        post(conn, Routes.transaction_path(conn, :create), %{
          quote_currency: "EOS",
          quote_currency_amount: 10.5,
          status: "executed",
          type: "stock_buy"
        })

      conn =
        post(conn, Routes.transaction_path(conn, :create), %{
          quote_currency: "EOS",
          quote_currency_amount: 100.7,
          status: "executed",
          type: "stock_buy"
        })

      conn =
        post(conn, Routes.transaction_path(conn, :create), %{
          quote_currency: "EOS",
          quote_currency_amount: 100.7,
          status: "executed",
          type: "adjustment"
        })

      conn =
        post(conn, Routes.transaction_path(conn, :create), %{
          quote_currency: "EOS",
          quote_currency_amount: 10.5,
          status: "executed",
          type: "adjustment"
        })

      conn = get(conn, Routes.transaction_path(conn, :ss_quote_currency_amount) <> "?each_type")

      assert [
               %{"type" => "stock_buy", "min" => 10.5, "max" => 100.7, "avg" => 55.6},
               %{"type" => "adjustment", "min" => 10.5, "max" => 100.7, "avg" => 55.6}
             ] = json_response(conn, 200)
    end

    test "gets min, max and avg of quote_currency_amount for each type and quote_currency combo",
         %{conn: conn} do
      conn =
        post(conn, Routes.transaction_path(conn, :create), %{
          quote_currency: "EOS",
          quote_currency_amount: 10.5,
          status: "executed",
          type: "adjustment"
        })

      conn =
        post(conn, Routes.transaction_path(conn, :create), %{
          quote_currency: "BTC",
          quote_currency_amount: 100.7,
          status: "executed",
          type: "adjustment"
        })

      conn =
        post(conn, Routes.transaction_path(conn, :create), %{
          quote_currency: "EOS",
          quote_currency_amount: 10.5,
          status: "executed",
          type: "stock_buy"
        })

      conn =
        post(conn, Routes.transaction_path(conn, :create), %{
          quote_currency: "BTC",
          quote_currency_amount: 100.7,
          status: "executed",
          type: "stock_buy"
        })

      conn =
        post(conn, Routes.transaction_path(conn, :create), %{
          quote_currency: "BTC",
          quote_currency_amount: 10.5,
          status: "executed",
          type: "stock_buy"
        })

      conn =
        get(
          conn,
          Routes.transaction_path(conn, :ss_quote_currency_amount) <>
            "?each_type_quote_currency_combo"
        )

      assert [
               %{
                 "avg" => 100.7,
                 "max" => 100.7,
                 "min" => 100.7,
                 "type" => "adjustment",
                 "quote_currency" => "BTC"
               },
               %{
                 "avg" => 10.5,
                 "max" => 10.5,
                 "min" => 10.5,
                 "type" => "adjustment",
                 "quote_currency" => "EOS"
               },
               %{
                 "avg" => 55.6,
                 "max" => 100.7,
                 "min" => 10.5,
                 "quote_currency" => "BTC",
                 "type" => "stock_buy"
               },
               %{
                 "avg" => 10.5,
                 "max" => 10.5,
                 "min" => 10.5,
                 "quote_currency" => "EOS",
                 "type" => "stock_buy"
               }
             ] = json_response(conn, 200)
    end
  end

  defp create_transaction(_) do
    transaction = transaction_fixture()
    %{transaction: transaction}
  end
end
