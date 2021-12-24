# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :currencyconverter,
  ecto_repos: [Currencyconverter.Repo]

# Configures the endpoint
config :currencyconverter, CurrencyconverterWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: CurrencyconverterWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: Currencyconverter.PubSub,
  live_view: [signing_salt: "KOoRlzeN"]

# Configures Elixir's Logger to log to file
# ensure https://github.com/onkel-dirtus/logger_file_backend
# is installed in deps of the project in mix.exs
# reuses the original phoenix logging format.
config :logger, backends: [{LoggerFileBackend, :request_log}],
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Keep a seperate log file for each env.
# logs are stored in the root directory of the application
# inside the logs folder.
# Note: Remember to specify the format along with the metadata required.
# Configurable per LoggerFileBackend.
config :logger, :request_log,
  path: "#{File.cwd!()}/logs/request.#{Mix.env}.log",
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id],
  level: :error

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
