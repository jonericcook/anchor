defmodule AnchorWeb.TransactionController do
  use AnchorWeb, :controller

  alias Anchor.Transactions
  alias Anchor.Transactions.Transaction

  action_fallback AnchorWeb.FallbackController

  def create(conn, transaction_params) do
    with {:ok, %Transaction{} = transaction} <-
           Transactions.create_transaction(transaction_params) do
      conn
      |> put_status(:created)
      |> render("show.json", transaction: transaction)
    end
  end

  def delete(conn, %{"id" => id}) do
    case Transactions.get_transaction(id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{errors: %{detail: "transaction id #{id} not found"}})

      transaction ->
        with {:ok, %Transaction{}} <- Transactions.delete_transaction(transaction) do
          send_resp(conn, :no_content, "")
        end
    end
  end

  def ss_quote_currency_amount(%Plug.Conn{query_params: %{"entire_dataset" => _}} = conn, _params) do
    json(conn, Transactions.ss_quote_currency_entire_dataset())
  end

  def ss_quote_currency_amount(%Plug.Conn{query_params: %{"stock_buy" => _}} = conn, _params) do
    json(conn, Transactions.ss_quote_currency_stock_buy())
  end

  def ss_quote_currency_amount(%Plug.Conn{query_params: %{"each_type" => _}} = conn, _params) do
    json(conn, Transactions.ss_quote_currency_each_type())
  end

  def ss_quote_currency_amount(%Plug.Conn{query_params: %{"each_type_quote_currency_combo" => _}} = conn, _params) do
    json(conn, Transactions.ss_quote_currency_each_type_quote_currency_combo())
  end
end
