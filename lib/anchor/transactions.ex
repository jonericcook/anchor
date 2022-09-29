defmodule Anchor.Transactions do
  @moduledoc """
  The Transactions context.
  """

  import Ecto.Query, warn: false
  import Ecto.OLAP.GroupingSets
  alias Anchor.Repo

  alias Anchor.Transactions.Transaction

  @doc """
  Gets a single transaction.

  Raises `Ecto.NoResultsError` if the Transaction does not exist.

  ## Examples

      iex> get_transaction(123)
      %Transaction{}

      iex> get_transaction(456)
      ** nil

  """
  def get_transaction(id), do: Repo.get(Transaction, id)

  @doc """
  Creates a transaction.

  ## Examples

      iex> create_transaction(%{field: value})
      {:ok, %Transaction{}}

      iex> create_transaction(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_transaction(attrs \\ %{}) do
    %Transaction{}
    |> Transaction.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Deletes a transaction.

  ## Examples

      iex> delete_transaction(transaction)
      {:ok, %Transaction{}}

      iex> delete_transaction(transaction)
      {:error, %Ecto.Changeset{}}

  """
  def delete_transaction(%Transaction{} = transaction) do
    Repo.delete(transaction)
  end

  def ss_quote_currency_entire_dataset() do
    query =
      from t in Transaction,
        select: %{
          min: min(t.quote_currency_amount),
          max: max(t.quote_currency_amount),
          avg: avg(t.quote_currency_amount)
        }

    Repo.one(query)
  end

  def ss_quote_currency_stock_buy() do
    query =
      from t in Transaction,
        where: t.type == "stock_buy",
        select: %{
          min: min(t.quote_currency_amount),
          max: max(t.quote_currency_amount),
          avg: avg(t.quote_currency_amount)
        }

    Repo.one(query)
  end

  def ss_quote_currency_each_type() do
    query =
      from t in Transaction,
        group_by: t.type,
        select: %{
          type: t.type,
          min: min(t.quote_currency_amount),
          max: max(t.quote_currency_amount),
          avg: avg(t.quote_currency_amount)
        }

    Repo.all(query)
  end

  def ss_quote_currency_each_type_quote_currency_combo() do
    query =
      from t in Transaction,
        group_by: grouping_sets([{t.type, t.quote_currency}]),
        select: %{
          type: t.type,
          quote_currency: t.quote_currency,
          min: min(t.quote_currency_amount),
          max: max(t.quote_currency_amount),
          avg: avg(t.quote_currency_amount)
        }

    Repo.all(query)
  end
end
