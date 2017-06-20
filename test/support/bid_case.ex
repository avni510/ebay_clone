defmodule EbayClone.BidCase do
  import EbayClone.ItemCase

  alias EbayClone.Bid
  alias EbayClone.Repo

  def create_bid(price, item_id, user_id) do
    attrs = %{price: price, item_id: item_id, user_id: user_id}

    changeset = Bid.changeset(%Bid{}, attrs)

    Repo.insert(changeset)
  end
end
