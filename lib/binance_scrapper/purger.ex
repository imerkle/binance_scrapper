# delete all data every 2 days
defmodule BinanceScrapper.PurgeIt do
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
    
    minutes = 60*60*24*2
    now = DateTime.utc_now |> DateTime.to_unix()
      
    timestamp = DateTime.from_unix!(now - minutes)  |> DateTime.to_naive


    BinanceScrapper.History
    |> where([u], u.inserted_at < ^timestamp)
    |> BinanceScrapper.Repo.delete_all

    schedule_work() # Reschedule once more
    {:noreply, state}
  end

  defp schedule_work() do
    Process.send_after(self(), :work, 3 * 24 * 60 * 60 * 1000) #ms
  end
end