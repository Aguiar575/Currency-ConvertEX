defmodule CurrencyconverterWeb.Router do
  use CurrencyconverterWeb, :router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/api", CurrencyconverterWeb do
    pipe_through(:api)

    post("/convert", ConverterController, :convert)
    get("/show-user/:user_id", ConverterController, :show_user)
  end
end
