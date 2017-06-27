defmodule EbayClone.Awarder do
  use GenServer
  import Ecto.Query

  alias EbayClone.Repo
  alias EbayClone.Item

  def start_link do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    execute()
    {:ok, state}
  end

  def handle_info(:award, state) do
    execute()
    {:noreply, state}
  end

  defp execute() do
    items_to_be_updated = Repo.all(query())
    Enum.map(items_to_be_updated, fn(item) -> update_item(item) end)
    one_second = 60 * 1000
    Process.send_after(self(), :award, one_second)
  end

  defp query do
    date = DateTime.utc_now()
    from item in Item,
      where: item.end_date < ^date and
             item.awarded == false
  end

  defp update_item(item) do
    changeset = Item.changeset(item, %{awarded: true})
    Repo.update(changeset)
  end
end
