defmodule EbayClone.BidControllerTest do
  use EbayClone.ConnCase
  import EbayClone.ItemCase

  alias EbayClone.Bid

  describe "create_item_bid" do
    test "it creates a bid entry for the specified item when bid price is valid", %{conn: conn} do
      {:ok, item} = create_item("foo@example.com",
                                "test password",
                                %{DateTime.utc_now | year: DateTime.utc_now.year + 1},
                                "item 1",
                                "foo",
                                42)
      conn = conn |> assign(:current_user, item.user_id)
      bid_params = %{price: 100}

      conn = post conn, bid_path(conn, :create_item_bid, item), %{id: item.id, bid: bid_params}

      assert redirected_to(conn) == item_path(conn, :show, item)
      assert Repo.get_by(Bid, price: bid_params.price)
    end

    test "does not create a bid and renders errors when data is invalid", %{conn: conn} do
      {:ok, item} = create_item("foo@example.com",
                                "test password",
                                %{DateTime.utc_now | year: DateTime.utc_now.year + 1},
                                "item 1",
                                "foo",
                                42)
      conn = conn |> assign(:current_user, item.user_id)
      bid_params = %{price: -1}

      conn = post conn,
             bid_path(conn, :create_item_bid, item),
             %{id: item.id, bid: bid_params}

      assert Repo.aggregate(Bid, :count, :id) == 0
      assert html_response(conn, 200) =~ "Show item"
    end
  end

  describe "show_bids_per_user" do
    test "it renders a template to display the users bids" do
    end
  end
end
