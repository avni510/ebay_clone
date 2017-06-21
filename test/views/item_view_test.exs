defmodule EbayClone.ItemViewTest do
  use EbayClone.ConnCase, async: true
  import EbayClone.ItemCase

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
end
