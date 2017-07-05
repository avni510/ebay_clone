defmodule EbayClone.BidController do
  use EbayClone.Web, :controller

  alias EbayClone.SessionInteractor
  alias EbayClone.Bid
  alias EbayClone.BidInteractor

  def create_item_bid(conn, %{"id" => id, "bid" => bid_params}) do
    current_user = SessionInteractor.current_user(conn)
    bid_params
    |> to_bid_data(id, current_user)
    |> BidInteractor.insert
    |> case do
      {:ok, _bid} ->
        conn
        |> put_flash(:info, "Successfully submitted a bid")
        |> redirect(to: item_path(conn, :show, id))
      {:error, changeset} ->
        item = Repo.get!(EbayClone.Item, id)
        render(conn, EbayClone.ItemView, "show.html", item: item, changeset: changeset)
    end
  end

  def show_bids_per_item(conn, %{"id" => id}) do
    items_and_bid_info = BidInteractor.get_bids_for_item(id)
    render(conn, "item_bids_show.html", items_and_bid_info: items_and_bid_info)
  end

  def show_bids_per_user(conn, %{"id" => id}) do
    {idVal, _} = Integer.parse(id)
    current_user = SessionInteractor.current_user(conn)
    if current_user.id == idVal do
      items_and_bid_info = BidInteractor.get_bids_for_user(id)
      render(conn, "user_bids_show.html", items_and_bid_info: items_and_bid_info)
    else
      conn |> send_resp(404, "Page Not Found")
    end
  end

  defp to_bid_data(%{"price" => price}, item_id, current_user) do
    %{
      item_id: item_id,
      user_id: current_user.id,
      price: price
    }
  end
end
