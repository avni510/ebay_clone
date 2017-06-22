defmodule EbayClone.BidControllerTest do
  use EbayClone.ConnCase
  import EbayClone.ItemCase
  import EbayClone.BidCase

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

  describe "show_bids_per_item" do
    test "it renders a template to display all the bids for an item", %{conn: conn} do
      {:ok, item_1} = create_item("foo@example.com",
                  "test password",
                  %{DateTime.utc_now | year: DateTime.utc_now.year + 1},
                  "item 1",
                  "foo",
                  42)
      {:ok, user_1} = create_user("bar@example.com", "fizzbuzz")
      conn = conn |> assign(:current_user, user_1.id)
      create_bid(45, item_1.id, user_1.id)
      {:ok, user_2} = create_user("fakeuser@example.com", "fizzbuzz")
      create_bid(70, item_1.id, user_2.id)

      conn = get conn, bid_path(conn, :show_bids_per_item, item_1.id)

      assert html_response(conn, 200) =~ "Bids for #{item_1.name}"
    end
  end

  describe "show_bids_per_user" do
    test "it renders a template to display all the bids for a user" do
    end
  end
end
