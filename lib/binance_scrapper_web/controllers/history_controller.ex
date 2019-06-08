# lib/controllers/order_controller.ex

defmodule BinanceScrapperWeb.HistoryController do
  	use BinanceScrapperWeb, :controller
    import Ecto.Query, warn: false

    def check(conn, %{"min" => minutes,"ticker" => ticker}) do
  		with_changes = BinanceScrapper.check(%{"min" => minutes,"ticker" => ticker})
      json(conn, with_changes)
    end

    def checkVolume(conn, %{"min" => minutes,"ticker" => ticker}) do
      with_changes = BinanceScrapper.checkVolume(%{"min" => minutes,"ticker" => ticker})
      json(conn, with_changes)
    end

    def cleardb(conn, params) do
      minutes = Map.get(params, "minutes", 60*60*24*2)

      now = DateTime.utc_now |> DateTime.to_unix()
      timestamp = DateTime.from_unix!(now - minutes)  |> DateTime.to_naive

      BinanceScrapper.History
      |> where([u], u.inserted_at < ^timestamp)
      |> BinanceScrapper.Repo.delete_all

      json(conn, %{deleted: true})
    end

end
