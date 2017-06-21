defmodule EbayClone.BidInteractor do
  import Ecto.Query

  alias EbayClone.Bid
  alias EbayClone.Repo
  alias EbayClone.Item

  def get_bids_for_item(item_id) do
    query = from bid in Bid,
      where: bid.item_id == ^item_id,
      join: item in Item, on: bid.item_id == item.id,
      select: %{bid_price: bid.price,
                bid_inserted_at: bid.inserted_at,
                item_name: item.name,
                item_id: item.id}

    Repo.all(query)
  end

  def get_bids_for_user(user_id) do
    query = from bid in Bid,
      where: bid.user_id == ^user_id,
      join: item in Item, on: bid.item_id == item.id,
      select: %{bid_price: bid.price,
                bid_inserted_at: bid.inserted_at,
                bid_user_id: bid.user_id,
                item_name: item.name,
                item_id: item.id}
    Repo.all(query)
  end
end

