defmodule EbayClone.BidController do
  use EbayClone.Web, :controller

  alias EbayClone.Session
  alias EbayClone.Bid

  def create_item_bid(conn, %{"id" => id, "bid" => bid_params}) do
    current_user = Session.current_user(conn)
    final_params = Map.merge(bid_params, %{"item_id" => id, "user_id" => current_user.id})
    changeset = Bid.changeset(%Bid{}, final_params)

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
