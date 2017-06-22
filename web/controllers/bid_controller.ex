defmodule EbayClone.BidController do
  use EbayClone.Web, :controller

  alias EbayClone.Session
  alias EbayClone.Bid

  def create_item_bid(conn, %{"id" => id, "bid" => bid_params}) do
    current_user = Session.current_user(conn)
    changeset = create_changeset(bid_params, id, current_user.id)
    insert_bid(conn, changeset, id)
  end

  def show_bids_per_item(conn, %{"id" => id}) do
    items_and_bid_info = EbayClone.BidInteractor.get_bids_for_item(id)
    render(conn, "item_bids_show.html", items_and_bid_info: items_and_bid_info)
  end

  def show_bids_per_user(conn, _params) do
  end

  defp create_changeset(bid_params, item_id, user_id) do
    final_params = Map.merge(bid_params, %{"item_id" => item_id, "user_id" => user_id})
    Bid.changeset(%Bid{}, final_params)
  end

  defp insert_bid(conn, changeset, id) do
    case Repo.insert(changeset) do
      {:ok, _item} ->
        conn
        |> put_flash(:info, "Successfully submitted a bid")
        |> redirect(to: item_path(conn, :show, id))
      {:error, changeset} ->
        item = Repo.get!(EbayClone.Item, id)
        render(conn, EbayClone.ItemView, "show.html", item: item, changeset: changeset)
    end
  end
end
