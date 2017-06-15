defmodule EbayClone.ItemTest do
  use EbayClone.ModelCase
  import EbayClone.UserCase

  alias EbayClone.Item

  def valid_attrs do
    {:ok, user} = create_user("foo@example.com", "test password")
    %{end_date: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2018},
      name: "some content",
      start_price: 42,
      user_id: user.id}
  end

  describe "changeset" do
    test "changeset with valid attributes" do
      changeset = Item.changeset(%Item{}, valid_attrs())

      assert changeset.valid?
    end

    test "changeset with invalid attributes" do
      changeset = Item.changeset(%Item{}, %{})

      refute changeset.valid?
    end

    test "changeset is invalid if a name is already taken" do
      attrs = valid_attrs()
      item = Item.changeset(%Item{}, attrs)
      Repo.insert(item)

      attrs = Map.merge(attrs, %{description: "foo"})
      clone_attrs = %{attrs | start_price: 42}
      item_clone = Item.changeset(%Item{}, clone_attrs)

      assert {:error, changeset} = Repo.insert(item_clone)
      assert changeset.errors[:name] == {"has already been taken", []}
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

    test "changeset is invalid if user_id does not exist" do
      invalid_attrs = %{valid_attrs() | user_id: -1}
      invalid_item = Item.changeset(%Item{}, invalid_attrs)

      assert {:error, changeset} = Repo.insert(invalid_item)
      assert changeset.errors[:user_id] == {"does not exist", []}
    end

    test "changeset is invalid if date is in the past" do
      invalid_attrs = %{valid_attrs() |
                end_date: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}}

      assert {:end_date, "can't be a date in the past"} in errors_on(%Item{}, invalid_attrs)
    end
  end
end
