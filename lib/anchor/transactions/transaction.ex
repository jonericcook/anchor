defmodule Anchor.Transactions.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  schema "transactions" do
    field :quote_currency, :string
    field :quote_currency_amount, :float
    field :status, :string
    field :type, :string

    timestamps()
  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:type, :status, :quote_currency, :quote_currency_amount])
    |> validate_required([:type, :status, :quote_currency, :quote_currency_amount])
  end
end
