defmodule EbayClone.ItemInteractorTest do
  use EbayClone.ConnCase
  import EbayClone.UserCase
  import EbayClone.ItemCase
  import EbayClone.BidCase

  alias EbayClone.ItemInteractor

  describe "get_items_for_user_id" do
    test "it returns items for a specific user id" do
      create_item("foo@example.com",
                  "test password",
                  %{DateTime.utc_now | year: DateTime.utc_now.year + 1},
                  "item 1",
                  "foo",
                  42)
      {:ok, item_2} = create_item("bar@example.com",
                            "test password",
                            %{DateTime.utc_now | year: DateTime.utc_now.year + 1},
                            "item 2",
                            "bar",
                            42)

      items = ItemInteractor.get_items_for_user_id(item_2.user_id)

      assert length(items) == 1
      assert List.first(items).user_id == item_2.user_id
    end
  end

  describe "load/1" do
    test "loads item current price" do
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

      item = ItemInteractor.load(item.id)

      assert item.current_price == 1000
    end

    test "loads item base price when no bids" do
      {:ok, item} = create_item("foo@example.com",
                                "test password",
                                %{DateTime.utc_now | year: DateTime.utc_now.year + 1},
                                "item 1",
                                "foo",
                                42)

      item = ItemInteractor.load(item.id)

      assert item.current_price == 42
    end
  end
end
