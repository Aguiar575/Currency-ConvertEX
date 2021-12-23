defmodule CurrencyconverterWeb.Router do
  use CurrencyconverterWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", CurrencyconverterWeb do
    pipe_through :api

    post "/convert", ConversorController, :convert
    get "/convert/:id", ConversorController, :show
  end
end
