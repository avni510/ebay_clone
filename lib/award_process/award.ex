defmodule EbayClone.AwardProcess.Award do
  import Ecto.Query

  alias EbayClone.Repo
  alias EbayClone.Item
  alias EbayClone.Bid

  def execute do
    items_to_be_updated = Repo.all(items_to_be_awarded_query())
    Enum.map(items_to_be_updated, fn(item) -> update_item(item) end)
    twenty_four_hours = 24 * 60 * 60 * 1000
    Process.send_after(self(), :award, twenty_four_hours)
  end

  defp items_to_be_awarded_query do
    date = DateTime.utc_now()
    from item in Item,
      where: item.end_date <= ^date and
             item.awarded == false
  end

  defp update_item(item) do
    winner_id = get_winner_id(item)
    changeset = Item.changeset(item, %{awarded: true, winner_id: winner_id})
    Repo.update(changeset)
  end

  defp find_highest_bid_query(item) do
    from bid in Bid,
      where: ^item.id == bid.item_id,
      order_by: [desc: bid.price],
      limit: 1
  end

  defp get_winner_id(item) do
    bid = Repo.one(find_highest_bid_query(item))
    bid.user_id
  end
end
