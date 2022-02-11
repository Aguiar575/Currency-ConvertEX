defmodule CurrencyconverterWeb.Router do
  use CurrencyconverterWeb, :router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/api", CurrencyconverterWeb do
    pipe_through(:api)

    post("/converter/convert", ConverterController, :convert)
    get("/users/get-user/:user_id", UsersController, :get_user)
  end
end
