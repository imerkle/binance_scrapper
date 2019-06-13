defmodule BinanceScrapper.PriceChecker do
    use GenServer

    def start_link do
      GenServer.start_link(__MODULE__, %{})
    end

    def init(state) do
      :ets.new(:coins, [:set, :protected, :named_table])

      schedule_work() # Schedule work to be performed at some point
      {:ok, state}
    end

    @base Application.get_env(:binance_scrapper, :base)
    @ignore Application.get_env(:binance_scrapper, :ignore)
    @time_skip Application.get_env(:binance_scrapper, :time_skip)
    @pump_percent Application.get_env(:binance_scrapper, :pump_percent)
    @pump_time Application.get_env(:binance_scrapper, :pump_time)
    @pump_interval Application.get_env(:binance_scrapper, :pump_interval)
    @vol Application.get_env(:binance_scrapper, :vol)

    def handle_info(:work, state) do
      coins = BinanceScrapper.check(%{"min" => @pump_time, "ticker" => @base})
      for x <- coins do
        cx = :ets.lookup(:coins, x["symbol"])

        good = if cx != [] do
          y = Enum.at(cx, 0)
          y1 = Tuple.to_list(y)
          y2 = Enum.at(y1, 1)

          #if alerted before 7 min then good else spam
          if :os.system_time(:millisecond) - y2 > @time_skip do
            true
          else
            false
          end
        else
          true
        end

        if good && x["change"] > @pump_percent && x["_volume"] > @vol && !Enum.member?(@ignore, x["symbol"]) do
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
          {:ok, _result} = Nadia.send_message("-298080197", msg)
        end
      end

      schedule_work() # Reschedule once more
      {:noreply, state}
    end

    defp schedule_work() do
      Process.send_after(self(), :work, @pump_interval)
    end
  end
