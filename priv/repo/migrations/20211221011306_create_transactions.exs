defmodule Currencyconversor.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add :userId, :integer
      add :originCurrency, :string
      add :originCurrencyValue, :integer
      add :destinationCurrency, :string
      add :conversionFee, :integer

      timestamps()
    end
  end
end
