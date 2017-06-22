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
      create_bid(45, item_1.id, user_1.id)
      {:ok, user_2} = create_user("fakeuser@example.com", "fizzbuzz")
      create_bid(70, item_1.id, user_2.id)
      conn = conn |> assign(:current_user, user_1.id)

      conn = get conn, bid_path(conn, :show_bids_per_item, item_1.id)

      assert html_response(conn, 200) =~ "Bids for #{item_1.name}"
    end

    test "returns a 404 if item does not exist", %{conn: conn} do
      {:ok, user} = create_user("bar@example.com", "fizzbuzz")
      conn = conn |> assign(:current_user, user.id)
      invalid_item_id = -1


      assert_error_sent 404, fn ->
        get conn, bid_path(conn, :show_bids_per_item, invalid_item_id)
      end
    end

    test "if there are no bids for an item, a template is rendered to display that there are no bids", %{conn: conn} do
      {:ok, user} = create_user("bar@example.com", "fizzbuzz")
      conn = conn |> assign(:current_user, user.id)
      {:ok, item} = create_item("foo@example.com",
                                "test password",
                                %{DateTime.utc_now | year: DateTime.utc_now.year + 1},
                                "item 1",
                                "foo",
                                42)

      conn = get conn, bid_path(conn, :show_bids_per_item, item.id)

      assert html_response(conn, 200) =~ "There Are No Bids For This Item"
    end
  end

  describe "show_bids_per_user" do
    test "it renders a template to display all the bids for a user" do
      {:ok, item_1} = create_item("foo@example.com",
                                "test password",
                                %{DateTime.utc_now | year: DateTime.utc_now.year + 1},
                                "item 1",
                                "foo",
                                10)
      {:ok, user_1} = create_user("bar@example.com", "fizzbuzz")
      create_bid(20, item_1.id, user_1.id)
      {:ok, item_2} = create_item("foobar@example.com",
                                "test password",
                                %{DateTime.utc_now | year: DateTime.utc_now.year + 1},
                                "item 2",
                                "bar",
                                10)
      create_bid(25, item_2.id, user_1.id)
      conn = build_conn() |> assign(:current_user, user_1.id)

      conn = get conn, bid_path(conn, :show_bids_per_user, user_1.id)

      assert html_response(conn, 200) =~ "Below is A List of All Your Bids"
    end

    test "returns a 404 if user does not exist", %{conn: conn} do
      {:ok, user} = create_user("bar@example.com", "fizzbuzz")
      conn = conn |> assign(:current_user, user.id)
      invalid_user_id = -1

      conn = get conn, bid_path(conn, :show_bids_per_user, invalid_user_id)

      assert conn.status == 404
    end

    test "if there are no bids for a user, a template is rendered to display that there are no bids", %{conn: conn} do
      {:ok, user} = create_user("bar@example.com", "fizzbuzz")
      conn = conn |> assign(:current_user, user.id)

      conn = get conn, bid_path(conn, :show_bids_per_user, user.id)

      assert html_response(conn, 200) =~ "There Are No Bids For You"
    end

    test "a user should only be able to see their bids and not others", %{conn: conn} do
      {:ok, user_1} = create_user("foo@example.com", "fizzbuzz")
      {:ok, user_2} = create_user("bar@example.com", "test password")
      conn = conn |> assign(:current_user, user_1.id)

      conn = get conn, bid_path(conn, :show_bids_per_user, user_2.id)

      assert conn.status == 404
    end
  end
end
