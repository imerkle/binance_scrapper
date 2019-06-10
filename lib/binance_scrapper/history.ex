defmodule BinanceScrapper.History do
  use Ecto.Schema
  import Ecto.Changeset

  schema "history" do
    field(:prices, :string)

    timestamps()
  end

  def changeset(history, params) do
    history
    |> cast(params, [:prices])
  end

end
