defmodule Anchor.TransactionsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Anchor.Transactions` context.
  """

  @doc """
  Generate a transaction.
  """
  def transaction_fixture(attrs \\ %{}) do
    {:ok, transaction} =
      attrs
      |> Enum.into(%{
        quote_currency: "EOS",
        quote_currency_amount: 120.5,
        status: "executed",
        type: "adjustment"
      })
      |> Anchor.Transactions.create_transaction()

    transaction
  end
end
