defmodule EbayClone.ItemViewTest do
  use EbayClone.ConnCase, async: true
  import EbayClone.ItemCase
  import EbayClone.BidCase
  import EbayClone.UserCase

  alias EbayClone.Item
  alias EbayClone.ItemView

  describe "filter_for_future_date" do
    test "only items with end date in the future are returned" do
      create_item("foo@example.com",
                  "test password",
                  %{DateTime.utc_now | year: DateTime.utc_now.year + 1},
                  "item 1",
                  "foo",
                  42)
      create_item("bar@example.com",
                  "test password",
                  %{DateTime.utc_now | year: DateTime.utc_now.year - 1},
                  "item 2",
                  "bar",
                  42)

      items = ItemView.filter_for_future_date(Repo.all(Item))

      assert length(items) == 1
      assert List.first(items).name == "item 1"
    end
  end

  describe "find_current_price" do
    test "it returns the highest bid for an item" do
      {:ok, item} = create_item("foo@example.com",
                                "test password",
                                %{DateTime.utc_now | year: DateTime.utc_now.year + 1},
                                "item 1",
                                "foo",
                                42)
      {:ok, user_1} = create_user("bar@example.com", "fizzbuzz")
      {:ok, user_2} = create_user("fakeuser@example.com", "password")
      {:ok, user_3} = create_user("foobar@example.com", "test password")
      create_bid(50, item.id, user_1.id)
      create_bid(70, item.id, user_2.id)
      create_bid(1000, item.id, user_3.id)

      price = ItemView.find_current_price(item.id)

      assert price == 1000
    end

    test "it returns the items start price if no bids have been placed" do
      {:ok, item} = create_item("foo@example.com",
                                "test password",
                                %{DateTime.utc_now | year: DateTime.utc_now.year + 1},
                                "item 1",
                                "foo",
                                42)

      price = ItemView.find_current_price(item.id)

      assert price == 42
    end
  end
end
