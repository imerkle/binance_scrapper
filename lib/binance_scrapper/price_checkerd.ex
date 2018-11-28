defmodule BinanceScrapper.PriceCheckerd do
    use GenServer

    alias BinanceScrapper.History
    def start_link do
      GenServer.start_link(__MODULE__, %{})
    end
  
    def init(state) do
      :ets.new(:coinsx, [:set, :protected, :named_table])
      
      schedule_work() # Schedule work to be performed at some point
      {:ok, state}
    end
  
    def handle_info(:work, state) do
      coins = BinanceScrapper.check(%{"min" => "6","ticker" => "BTC"})
      for x <- coins do
        cx = :ets.lookup(:coinsx, x["symbol"])
        
        good = if cx != [] do
          y = Enum.at(cx, 0)
          y1 = Tuple.to_list(y)
          y2 = Enum.at(y1, 1)
          
          #if alerted before 7 min then good else spam
          if :os.system_time(:millisecond) - y2 > 420000 do
            true
          else
            false
          end
        else
          true 
        end

        if good && x["change"] < -1 && x["symbol"]!="NPXSBTC" && x["symbol"]!="HOTBTC" && x["symbol"]!="DENTBTC"  do
          msg = 
          """
          
          #{x["symbol"]}
          Price: #{x["price"]}
          Before Price: #{x["before_price"]}
          Change: #{x["change"]}%
          Volume: #{x["_volume"]}
          
          """
          :ets.insert(:coins, {x["symbol"], :os.system_time(:millisecond)})
            #Nostrum.Api.create_message(297409922738421760, msg)
            # discord sucks no notifications so added telegram
          Nadia.send_message("-281839565", msg)
        end
      end
        
      schedule_work() # Reschedule once more
      {:noreply, state}
    end
  
    defp schedule_work() do
      Process.send_after(self(), :work, 1 * 1 * 5 * 1000) # Run every day 24 * 60 * 60 * 1000
    end
  end