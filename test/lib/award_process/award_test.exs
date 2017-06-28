defmodule EbayClone.AwardProcess.AwardTest do
  use EbayClone.ConnCase
  import EbayClone.ItemCase

  alias EbayClone.AwardProcess.Award
  alias EbayClone.Item
  alias EbayClone.Repo

  describe "execute" do
    test "it changes the item awarded attribute to true for entries with an end date in the past the awarded set to false" do
      {:ok, item_1} = create_item("foo@example.com",
                                  "test password",
                                  %{DateTime.utc_now | second: DateTime.utc_now.second + 1},
                                  "item 1",
                                  "bar",
                                  42)
      create_item("bar@example.com",
                   "test password",
                   %{DateTime.utc_now | year: DateTime.utc_now.year + 1},
                   "item 2",
                   "test description",
                   10)
      :timer.sleep(1000)

      Award.execute()

      updated_item = Repo.get(Item, item_1.id)
      assert updated_item.awarded == true
    end

    test "it does not change the item awarded attribute to true for entries with an end date in the future" do
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

      Award.execute()

      item = Repo.get(Item, item_2.id)
      assert item.awarded == false
    end
  end
end
