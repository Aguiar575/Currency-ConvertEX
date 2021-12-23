defmodule Currencyconverter.Repo do
  use Ecto.Repo,
    otp_app: :currencyconverter,
    adapter: Ecto.Adapters.SQLite3
end
