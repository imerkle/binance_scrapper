# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :binance_scrapper,
  ecto_repos: [BinanceScrapper.Repo]

# Configures the endpoint
config :binance_scrapper, BinanceScrapperWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "pc3A3T/h0dHbqHUIWcw/UW73Wx+iRYBFAi0gyrBjHkpNnr9z+YGSP0PTowPI/dSW",
  render_errors: [view: BinanceScrapperWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: BinanceScrapper.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.

config :binance,
  api_key: "4GfCdy8aaJV9uCRASQmKT7i8MErK4E9Gxf7lrUqQ6jvjMedOLVWzE4UTs1EeRgh3",
  secret_key: "V7RAzL0H7fe7nc07h0rHpVjlswj5PCZWdDBhsMJ8xXy2FcVE8RVeJnwOkHrHnWFN"

config :nadia,
  token: "782434163:AAEDBNC-nxsRnkhosq4Cvt0kPZCnSR8mp8A"

config :binance_scrapper,
  base: "BTC",
  ignore: ["NPXSBTC", "HOTBTC", "DENTBTC", "BTTBTC"],
  time_skip: 420000, #7 minutes
  pump_time: "6",
  pump_percent: 2.5,
  pump_interval: 1 * 1 * 5 * 1000,
  dump_time: "6",
  dump_percent: -1,
  dump_interval: 1 * 1 * 5 * 1000

config :binance_scrapper, BinanceScrapper.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "binance_scrapper",
  hostname: "localhost",
  pool_size: 10

import_config "#{Mix.env}.exs"
