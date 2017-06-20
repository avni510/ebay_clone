defmodule EbayClone.ItemView do
  use EbayClone.Web, :view
  import Ecto.Query

  alias EbayClone.Repo
  alias EbayClone.Bid
  alias EbayClone.Item

  def filter_for_future_date(items) do
    today = DateTime.utc_now()
    Enum.filter(items,
                fn(item) ->
                  DateTime.compare(item.end_date, today) == :gt end)
  end

  def find_current_price(item_id) do
    query = from bid in Bid,
      where: bid.item_id == ^item_id,
      select: bid.price
    all_bid_prices = Repo.all(query)
    retrieve_display_price(all_bid_prices, item_id)
  end

  defp retrieve_display_price(all_prices, item_id) do
    if Enum.empty?(all_prices) do
      item = Repo.get(Item, item_id)
      item.start_price
    else
      Enum.max(all_prices)
    end
  end
end
