defmodule Currencyconverter.Transaction do
  @moduledoc """
  The Transaction context.
  """

  import Ecto.Query, warn: false
  alias Currencyconverter.Repo

  alias Currencyconverter.Transaction.Transactions

  @doc """
  Returns the list of transactions.

  ## Examples

      iex> list_transactions()
      [%Transactions{}, ...]

  """
  def list_transactions do
    Repo.all(Transactions)
  end

  @doc """
  Gets a single transactions.

  Raises `Ecto.NoResultsError` if the Transactions does not exist.

  ## Examples

      iex> get_transactions!(123)
      %Transactions{}

      iex> get_transactions!(456)
      ** (Ecto.NoResultsError)

  """
  def get_transactions!(id), do: Repo.get!(Transactions, id)

  @doc """
  Gets all transactions for an user id.

  Returns a empty list if the Transactions does not exist.

  ## Examples

      iex> get_by_user_id!(123)
      %Transactions{}

      iex> get_by_user_id!(456)
      []

  """
  def get_by_user_id!(user_id),
    do:
      Repo.all(
        from(t in Transactions,
          where: t.user_id == ^user_id,
          select: [
            t.user_id,
            t.origin_currency,
            t.origin_currency_value,
            t.destination_currency,
            t.conversion_rate,
            t.inserted_at
          ]
        )
      )

  @doc """
  Creates a transactions.

  ## Examples

      iex> create_transactions(%{field: value})
      {:ok, %Transactions{}}

      iex> create_transactions(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_transactions(attrs \\ %{}) do
    %Transactions{}
    |> Transactions.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a transactions.

  ## Examples

      iex> update_transactions(transactions, %{field: new_value})
      {:ok, %Transactions{}}

      iex> update_transactions(transactions, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_transactions(%Transactions{} = transactions, attrs) do
    transactions
    |> Transactions.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a transactions.

  ## Examples

      iex> delete_transactions(transactions)
      {:ok, %Transactions{}}

      iex> delete_transactions(transactions)
      {:error, %Ecto.Changeset{}}

  """
  def delete_transactions(%Transactions{} = transactions) do
    Repo.delete(transactions)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking transactions changes.

  ## Examples

      iex> change_transactions(transactions)
      %Ecto.Changeset{data: %Transactions{}}

  """
  def change_transactions(%Transactions{} = transactions, attrs \\ %{}) do
    Transactions.changeset(transactions, attrs)
  end
end
