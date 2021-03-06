defmodule EbayClone.BidInteractorTest do
  use EbayClone.ConnCase
  import EbayClone.ItemCase
  import EbayClone.BidCase
  import EbayClone.UserCase

  alias EbayClone.BidInteractor

  describe "get_bids_for_item" do
    test "it returns all the bids for a specific item" do
      {:ok, item_1} = create_item("foo@example.com",
                                  "test password",
                                  %{DateTime.utc_now | year: DateTime.utc_now.year + 1},
                                  "item 1",
                                  "foo",
                                  42)
      {:ok, user_1} = create_user("bar@example.com", "fizzbuzz")
      create_bid(45, item_1.id, user_1.id)
      {:ok, item_2} = create_item("testuser@example.com",
                                  "test password",
                                  %{DateTime.utc_now | year: DateTime.utc_now.year + 1},
                                  "item 2",
                                  "bar",
                                  10)
      {:ok, user_2} = create_user("fakeuser@example.com", "fizzbuzz")
      create_bid(20, item_2.id, user_2.id)

      bids_and_item_info = BidInteractor.get_bids_for_item(item_1.id)

      assert length(bids_and_item_info) == 1
      assert List.first(bids_and_item_info).item_id == item_1.id
    end

    test "error is raised if the item does not exist" do
      invalid_item_id = -1

      assert catch_error(BidInteractor.get_bids_for_item(invalid_item_id)).__struct__ == Ecto.NoResultsError
    end

    test ":no_bids is returned if there are no bids for an item" do
      {:ok, item} = create_item("foo@example.com",
                                  "test password",
                                  %{DateTime.utc_now | year: DateTime.utc_now.year + 1},
                                  "item 1",
                                  "foo",
                                  42)

      bids_and_item_info = BidInteractor.get_bids_for_item(item.id)

      assert bids_and_item_info == nil
    end
  end

  describe "get_bids_for_user" do
    test "it returns all the bids for a specific user" do
      {:ok, item} = create_item("foo@example.com",
                                "test password",
                                %{DateTime.utc_now | year: DateTime.utc_now.year + 1},
                                "item 1",
                                "foo",
                                10)
      {:ok, user_1} = create_user("bar@example.com", "fizzbuzz")
      {:ok, user_2} = create_user("fakeuser@example.com", "fizzbuzz")
      create_bid(20, item.id, user_1.id)
      create_bid(25, item.id, user_2.id)

      bids_and_item_info = BidInteractor.get_bids_for_user(user_1.id)

      assert length(bids_and_item_info) == 1
      assert List.first(bids_and_item_info).bid_user_id == user_1.id
    end
  end

  test ":invalid_user is returned if the user does not exist" do
    invalid_user_id = -1

    assert catch_error(BidInteractor.get_bids_for_user(invalid_user_id)).__struct__ == Ecto.NoResultsError
  end

  test "nil is returned if there are no bids for an item" do
    {:ok, user} = create_user("bar@example.com", "fizzbuzz")

    bids_and_item_info = BidInteractor.get_bids_for_user(user.id)

    assert bids_and_item_info == nil
  end
end
