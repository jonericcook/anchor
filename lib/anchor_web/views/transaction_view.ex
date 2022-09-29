defmodule AnchorWeb.TransactionView do
  use AnchorWeb, :view
  alias AnchorWeb.TransactionView

  def render("index.json", %{transactions: transactions}) do
    %{data: render_many(transactions, TransactionView, "transaction.json")}
  end

  def render("show.json", %{transaction: transaction}) do
    %{data: render_one(transaction, TransactionView, "transaction.json")}
  end

  def render("transaction.json", %{transaction: transaction}) do
    %{
      id: transaction.id,
      type: transaction.type,
      status: transaction.status,
      quote_currency: transaction.quote_currency,
      quote_currency_amount: transaction.quote_currency_amount
    }
  end
end
