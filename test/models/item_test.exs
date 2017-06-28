defmodule EbayClone.ItemTest do
  use EbayClone.ModelCase
  import EbayClone.UserCase
  import EbayClone.ItemCase
  import EbayClone.BidCase

  alias EbayClone.Item

  def valid_attrs do
    {:ok, user} = create_user("foo@example.com", "test password")
    %{end_date: %{DateTime.utc_now | year: DateTime.utc_now.year + 1},
      name: "some content",
      start_price: 42,
      user_id: user.id}
  end

  describe "changeset" do
    test "changeset with valid attributes" do
      changeset = Item.changeset(%Item{}, valid_attrs())

      assert changeset.valid?
    end

    test "changeset with is invalid if there are no attributes" do
      changeset = Item.changeset(%Item{}, %{})

      refute changeset.valid?
    end

    test "changeset is invalid if user id does not exist" do
      invalid_attrs = Map.delete(valid_attrs(), :user_id)

      assert {:user_id, "can't be blank"} in errors_on(%Item{}, invalid_attrs)
    end

    test "changeset is invalid if name does not exist" do
      invalid_attrs = Map.delete(valid_attrs(), :name)

      assert {:name, "can't be blank"} in errors_on(%Item{}, invalid_attrs)
    end

    test "changeset is invalid if start_price does not exist" do
      invalid_attrs = Map.delete(valid_attrs(), :start_price)

      assert {:start_price, "can't be blank"} in errors_on(%Item{}, invalid_attrs)
    end

    test "changeset is invalid if end_date does not exist" do
      invalid_attrs = Map.delete(valid_attrs(), :end_date)

      assert {:end_date, "can't be blank"} in errors_on(%Item{}, invalid_attrs)
    end

    test "changeset is invalid if user_id does not exist in database" do
      invalid_attrs = %{valid_attrs() | user_id: -1}
      invalid_item = Item.changeset(%Item{}, invalid_attrs)

      assert {:error, changeset} = Repo.insert(invalid_item)
      assert changeset.errors[:user_id] == {"does not exist", []}
    end

    test "changeset is invalid if date is now" do
      invalid_attrs = %{valid_attrs() |
                        end_date: DateTime.utc_now}

      assert {:end_date, "can't be a date in the past"} in errors_on(%Item{}, invalid_attrs)
    end

    test "changeset is invalid if date is in the past" do
      invalid_attrs = %{valid_attrs() |
                        end_date: %{DateTime.utc_now | year: DateTime.utc_now.year - 1}}

      assert {:end_date, "can't be a date in the past"} in errors_on(%Item{}, invalid_attrs)
    end

    test "changeset is invalid if price is less than 0" do
      invalid_attrs = %{valid_attrs() | start_price: -5}

      assert {:start_price, "can't be a number less than 0"} in errors_on(%Item{}, invalid_attrs)
    end

    test "changeset is invalid if winner_id does not reference a user_id from the users table" do
      invalid_attrs = Map.put(valid_attrs(), :winner_id, -1)
      invalid_item = Item.changeset(%Item{}, invalid_attrs)

      assert {:error, changeset} = Repo.insert(invalid_item)
      assert changeset.errors[:winner_id] == {"does not exist", []}
    end
  end

  describe "current_price" do
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

      price = Item.current_price(item.id)

      assert price == 1000
    end

    test "it returns the items start price if no bids have been placed" do
      {:ok, item} = create_item("foo@example.com",
                                "test password",
                                %{DateTime.utc_now | year: DateTime.utc_now.year + 1},
                                "item 1",
                                "foo",
                                42)

      price = Item.current_price(item.id)

      assert price == 42
    end
  end
end
