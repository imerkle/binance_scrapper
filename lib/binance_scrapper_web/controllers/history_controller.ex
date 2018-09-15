# lib/controllers/order_controller.ex

defmodule BinanceScrapperWeb.HistoryController do
  	use BinanceScrapperWeb, :controller
    import Ecto.Query, warn: false


  	def check(conn, %{"min" => minutes,"ticker" => ticker}) do
  		
      tickers = String.split(ticker, ",")

      {minutes, _} = Integer.parse(minutes)
      now = DateTime.utc_now |> DateTime.to_unix()
      
      timestamp = DateTime.from_unix!(now - minutes * 60 )  |> DateTime.to_naive

      history = BinanceScrapper.History
      |> where([u], u.inserted_at >= ^timestamp)
      |> limit(1)
      |>  BinanceScrapper.Repo.all
      
      present = BinanceScrapper.History 
      |> order_by(desc: :id)
      |> limit(1)
      |>  BinanceScrapper.Repo.all
      
      prices_before = Poison.decode!(Enum.at(history, 0).prices)
      prices_after = Poison.decode!(Enum.at(present, 0).prices)
      iprices_after = Enum.with_index(prices_after)

      with_changes = 
      Enum.map(iprices_after, fn{x, i} -> 
        {bp, _} = Float.parse(Enum.at(prices_before,i)["price"])
        {ap, _} = Float.parse(x["price"])

        %{
          "symbol"=> x["symbol"],
          "price"=>ap,
          "before_price"=> bp,
          "change"=> (ap - bp) / bp  * 100
        }
      end)
      |> Enum.filter(fn x ->  String.contains? x["symbol"], tickers end)
      |> Enum.sort_by(fn(x) -> -x["change"] end)

      json(conn, with_changes)
    end
    
  	def checkVolume(conn, %{"min" => minutes,"ticker" => ticker}) do
  		
      tickers = String.split(ticker, ",")

      {minutes, _} = Integer.parse(minutes)
      now = DateTime.utc_now |> DateTime.to_unix()
      
      timestamp = DateTime.from_unix!(now - minutes * 60 )  |> DateTime.to_naive

      history = BinanceScrapper.History
      |> where([u], u.inserted_at >= ^timestamp)
      |> limit(1)
      |>  BinanceScrapper.Repo.all
      
      present = BinanceScrapper.History 
      |> order_by(desc: :id)
      |> limit(1)
      |>  BinanceScrapper.Repo.all
      
      volume_before = Poison.decode!(Enum.at(history, 0).volume)
      volume_after = Poison.decode!(Enum.at(present, 0).volume)
      ivolume_after = Enum.with_index(volume_after)

      with_changes = 
      Enum.map(volume_after, fn{x, i} -> 
        {bv, _} = Float.parse(Enum.at(volume_before,i)["volume"])
        {av, _} = Float.parse(x["volume"])

        %{
          "symbol"=> x["symbol"],
          "volume"=>av,
          "before_volume"=> bv,
          "change"=> (av - bv) / bv  * 100
        }
      end)
      |> Enum.filter(fn x ->  String.contains? x["symbol"], tickers end)
      |> Enum.sort_by(fn(x) -> -x["change"] end)

      json(conn, with_changes)
  	end    

end