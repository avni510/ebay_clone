defmodule EbayClone.ItemView do
  use EbayClone.Web, :view
  import Ecto.Query

  alias EbayClone.Repo
  alias EbayClone.Bid
  alias EbayClone.Item

  def filter_for_future_date(items) do
    today = DateTime.utc_now()
    Enum.filter(items,
                fn(item) ->
                  DateTime.compare(item.end_date, today) == :gt end)
  end
end
