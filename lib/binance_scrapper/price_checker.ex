defmodule BinanceScrapper.PriceChecker do
    use GenServer
    import Ecto.Query, warn: false
  
    alias BinanceScrapper.History
  
    def start_link do
      GenServer.start_link(__MODULE__, %{})
    end
  
    def init(state) do
      schedule_work() # Schedule work to be performed at some point
      {:ok, state}
    end
  
    def handle_info(:work, state) do

      coins = BinanceScrapper.check(%{"min" => 5,"ticker" => "BTC"})

      for x <- coins do
        if x.change > 4 do
            msg = 
            """
                #{x.symbol}
                **Price:** #{x.price}
                **Before Price:** #{x.before_price}
                **Change:** #{x.before_price}%
                **Volume:** #{x._volume}
            """
        end
      end
        
      schedule_work() # Reschedule once more
      {:noreply, state}
    end
  
    defp schedule_work() do
      Process.send_after(self(), :work, 24 * 60 * 60 * 1000) # Run every day 24 * 60 * 60 * 1000
    end
  end