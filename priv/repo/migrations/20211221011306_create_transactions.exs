defmodule Currencyconversor.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add :user_id, :integer
      add :origin_currency, :string
      add :origin_currency_value, :integer
      add :destination_currency, :string
      add :conversion_rate, :integer

      timestamps()
    end
  end
end
