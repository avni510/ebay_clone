defmodule EbayClone.CloseProcess.CloseTest do
  use EbayClone.ConnCase
  import EbayClone.ItemCase
  import EbayClone.BidCase
  import EbayClone.UserCase

  alias EbayClone.CloseProcess.Close
  alias EbayClone.Item
  alias EbayClone.Repo

  describe "execute" do
    test "when there are bids for an item, it changes the item is_closed
          attribute to true and updates the winner_id for items with an
          end date in the past the is_closed set to false" do
      {:ok, item_1} = create_item("foo@example.com",
                                  "test password",
                                  %{DateTime.utc_now | second: DateTime.utc_now.second + 1},
                                  "item 1",
                                  "bar",
                                  42)
      {:ok, user_1} = create_user("testuser@example.com", "test password")
      {:ok, user_2} = create_user("fakeuser@example.com", "fizzbuzz")
      create_bid(50, item_1.id, user_1.id)
      create_bid(60, item_1.id, user_2.id)
      create_bid(90, item_1.id, user_1.id)
      {:ok, item_2} = create_item("bar@example.com",
                                  "test password",
                                  %{DateTime.utc_now | year: DateTime.utc_now.year + 1},
                                  "item 2",
                                  "test description",
                                  10)
      create_bid(20, item_2.id, user_1.id)
      create_bid(30, item_2.id, user_2.id)
      :timer.sleep(1000)

      Close.execute()

      updated_item = Repo.get(Item, item_1.id)
      assert updated_item.is_closed == true
      assert updated_item.winner_id == user_1.id
    end

    test "when there are no bids for an item, it changes the item is_closed
          attribute to true for items with an end date in the past the is_closed set to false" do
      {:ok, item_1} = create_item("foo@example.com",
                                  "test password",
                                  %{DateTime.utc_now | second: DateTime.utc_now.second + 1},
                                  "item 1",
                                  "bar",
                                  42)
      :timer.sleep(1000)

      Close.execute()

      updated_item = Repo.get(Item, item_1.id)
      assert updated_item.is_closed == true
      assert updated_item.winner_id == nil
    end

    test "it does not change the item is_closed attribute to true and does not
          update the winner_id attribute for items with an end date in the future" do
      create_item("foo@example.com",
                  "test password",
                  %{DateTime.utc_now | second: DateTime.utc_now.year + 1},
                  "item 1",
                  "bar",
                  42)
      {:ok, item_2} = create_item("bar@example.com",
                                  "test password",
                                  %{DateTime.utc_now | year: DateTime.utc_now.year + 1},
                                  "item 2",
                                  "test description",
                                  10)

      Close.execute()

      item = Repo.get(Item, item_2.id)
      assert item.is_closed == false
      assert item.winner_id == nil
    end
  end
end
