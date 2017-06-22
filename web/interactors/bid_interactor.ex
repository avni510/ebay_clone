defmodule EbayClone.BidInteractor do
  import Ecto.Query

  alias EbayClone.Bid
  alias EbayClone.Repo
  alias EbayClone.Item
  alias EbayClone.User

  def get_bids_for_item(item_id) do
    case item_exists?(item_id) do
      nil -> :invalid_item
      _ -> query_for_all_bids_for_item(item_id) |> return_value
    end
  end

  def get_bids_for_user(user_id) do
    case user_exists?(user_id) do
      nil -> :invalid_user
      _ -> query_for_all_bids_for_user(user_id) |> return_value
    end
  end

  defp query_for_all_bids_for_item(item_id) do
    query = from bid in Bid,
      where: bid.item_id == ^item_id,
      join: item in Item, on: bid.item_id == item.id,
      select: %{bid_price: bid.price,
                bid_inserted_at: bid.inserted_at,
                item_name: item.name,
                item_id: item.id}
    Repo.all(query)
  end

  defp item_exists?(item_id) do
    Repo.get(Item, item_id)
  end

  defp user_exists?(user_id) do
    Repo.get(User, user_id)
  end

  defp query_for_all_bids_for_user(user_id) do
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

  defp return_value(all_entries) do
    case all_entries do
      [] -> :no_bids
      result -> result
    end
  end
end

