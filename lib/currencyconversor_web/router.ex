defmodule CurrencyconversorWeb.Router do
  use CurrencyconversorWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", CurrencyconversorWeb do
    pipe_through :api
  end
end
