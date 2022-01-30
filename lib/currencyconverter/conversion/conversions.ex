defmodule Currencyconverter.Conversion.Conversions do
  use Ecto.Schema
  import Ecto.Changeset

  @required_params [:user_id, :from, :to, :amount]

  embedded_schema do
    field :user_id, :integer
    field :from, :string
    field :to, :string
    field :amount, :float

    timestamps()
  end

  @doc false
  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @required_params)
    |> validate_required(@required_params)
    |> validate_length(:from, is: 3)
    |> validate_length(:to, is: 3)
  end
end
