defmodule Currencyconversor.Repo do
  use Ecto.Repo,
    otp_app: :currencyconversor,
    adapter: Ecto.Adapters.SQLite3
end
