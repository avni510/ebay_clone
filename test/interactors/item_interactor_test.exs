defmodule EbayClone.ItemInteractorTest do
  use EbayClone.ConnCase
  import EbayClone.ItemCase

  alias EbayClone.ItemInteractor

  describe "get_items_for_user_id" do
    test "it returns items for a specific user id" do
      create_item("foo@example.com",
                  "test password",
                  %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2018},
                  "item 1",
                  "foo",
                  42)
      {:ok, item_2} = create_item("bar@example.com",
                            "test password",
                            %{day: 10, hour: 2, min: 0, month: 6, sec: 0, year: 2018},
                            "item 2",
                            "bar",
                            42)

      items = ItemInteractor.get_items_for_user_id(item_2.user_id)

      assert length(items) == 1
      assert List.first(items).user_id == item_2.user_id
    end
  end
end
