defmodule Anchor.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add :type, :string
      add :status, :string
      add :quote_currency, :string
      add :quote_currency_amount, :float

      timestamps()
    end
  end
end
