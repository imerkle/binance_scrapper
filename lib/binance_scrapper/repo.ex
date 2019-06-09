defmodule BinanceScrapper.Repo do
  use Ecto.Repo,
    otp_app: :binance_scrapper,
    adapter: Ecto.Adapters.Postgres
end
