defmodule Currencyconverter.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add :user_id, :string
      add :origin_currency, :string
      add :origin_currency_value, :string
      add :destination_currency, :string
      add :conversion_rate, :string

      timestamps()
    end
  end
end
