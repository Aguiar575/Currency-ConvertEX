defmodule CurrencyConverter.User.Users do
  use Ecto.Schema
  import Ecto.Changeset

  @required_params [:user_id]

  embedded_schema do
    field(:user_id, :integer)
  end

  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @required_params)
    |> validate_required(@required_params)
  end
end
