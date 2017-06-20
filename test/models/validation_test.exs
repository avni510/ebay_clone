defmodule EbayClone.PriceValidationTest do
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

  describe "validate_positive_integer" do
    test "if a number is less greater than 0 no error is returned" do
      changeset = Bid.changeset(%Bid{}, valid_attrs())

      assert Enum.empty?(changeset.errors)
    end

    test "if a number is less than 0 an error is returned" do
      invalid_attrs = %{valid_attrs() | price: -1}

      changeset = Bid.changeset(%Bid{}, invalid_attrs)

      assert changeset.errors == [price: {"can't be a number less than 0", []}]
    end
  end
end
