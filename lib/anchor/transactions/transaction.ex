defmodule Anchor.Transactions.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  @types ["adjustment", "stock_buy", "stock_sell", "deposit", "loan_margin_pnl", "sell", "buy"]
  @status ["executed"]
  @min_quote_currency_length 3

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
    |> validate_length(:quote_currency, min: @min_quote_currency_length)
    |> validate_inclusion(:type, @types)
    |> validate_inclusion(:status, @status)
  end
end
