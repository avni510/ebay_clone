defmodule EbayClone.ItemViewTest do
  use EbayClone.ConnCase, async: true
  import EbayClone.ItemCase

  alias EbayClone.Item
  alias EbayClone.ItemView

  describe "filter_for_future_date" do
    test "only items with end date in the future are returned" do
      create_item("foo@example.com",
                  "test password",
                  %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2018},
                  "item 1",
                  "foo",
                  42)
      create_item("bar@example.com",
                  "test password",
                  %{day: 10, hour: 2, min: 0, month: 6, sec: 0, year: 2016},
                  "item 2",
                  "bar",
                  42)

      items = ItemView.filter_for_future_date(Repo.all(Item))

      assert length(items) == 1
      assert List.first(items).name == "item 1"
    end
  end
end
