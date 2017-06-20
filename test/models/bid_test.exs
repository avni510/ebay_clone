defmodule EbayClone.BidTest do
  use EbayClone.ModelCase
  import EbayClone.ItemCase

  alias EbayClone.Bid

  def valid_attrs do
    {:ok, item} = create_item("foo@example.com",
                              "test password",
                              %{DateTime.utc_now | year: DateTime.utc_now.year + 1},
                              "item 1",
                              "foo",
                              42)
    %{price: 42, user_id: item.user_id, item_id: item.id}
  end

  describe "changeset" do
    test "changeset with valid attributes" do
      changeset = Bid.changeset(%Bid{}, valid_attrs())

      assert changeset.valid?
    end

    test "changeset is invalid if there are no attributes" do
      changeset = Bid.changeset(%Bid{}, %{})

      refute changeset.valid?
    end

    test "changeset is invalid if user_id does not exist" do
      invalid_attrs = Map.delete(valid_attrs(), :user_id)

      assert {:user_id, "can't be blank"} in errors_on(%Bid{}, invalid_attrs)
    end

    test "changeset is invalid if item_id does not exist" do
      invalid_attrs = Map.delete(valid_attrs(), :item_id)

      assert {:item_id, "can't be blank"} in errors_on(%Bid{}, invalid_attrs)
    end

    test "changeset is invalid if user_id does not exist in database" do
      invalid_attrs = %{valid_attrs() | user_id: -1}
      invalid_bid = Bid.changeset(%Bid{}, invalid_attrs)

      assert {:error, changeset} = Repo.insert(invalid_bid)
      assert changeset.errors[:user_id] == {"does not exist", []}
    end

    test "changeset is invalid if item_id does not exist in database" do
      invalid_attrs = %{valid_attrs() | item_id: -1}
      invalid_bid = Bid.changeset(%Bid{}, invalid_attrs)

      assert {:error, changeset} = Repo.insert(invalid_bid)
      assert changeset.errors[:item_id] == {"does not exist", []}
    end

    test "changeset is invalid if price is less than 0" do
      invalid_attrs = %{valid_attrs() | price: -5}

      assert {:price, "can't be a number less than 0"} in errors_on(%Bid{}, invalid_attrs)
    end
  end
end
