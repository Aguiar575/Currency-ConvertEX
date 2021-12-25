import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :currencyconverter, Currencyconverter.Repo,
  database: Path.expand("../currencyconverter_test.db", Path.dirname(__ENV__.file)),
  pool_size: 5,
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :currencyconverter, CurrencyconverterWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "IAR700tCq0Z8k3n11fOr82VzA9+VyjsFblIlRZ8KYEnvTTP0jpUuIjX7XYnD2yGr",
  server: false,
  api_key: System.get_env("API_KEY")

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

#import_config "test.secret.exs"
