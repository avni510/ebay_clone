defmodule EbayClone.AwardProcess.Award do
  import Ecto.Query

  alias EbayClone.Repo
  alias EbayClone.Item

  def execute do
    items_to_be_updated = Repo.all(query())
    Enum.map(items_to_be_updated, fn(item) -> update_item(item) end)
    twenty_four_hours = 24 * 60 * 60 * 1000
    Process.send_after(self(), :award, twenty_four_hours)
  end

  defp query do
    date = DateTime.utc_now()
    from item in Item,
      where: item.end_date <= ^date and
             item.awarded == false
  end

  defp update_item(item) do
    changeset = Item.changeset(item, %{awarded: true})
    Repo.update(changeset)
  end
end
