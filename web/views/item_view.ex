defmodule EbayClone.ItemView do
  use EbayClone.Web, :view

  def filter_for_future_date(items) do
    today = DateTime.utc_now()
    Enum.filter(items,
                fn(item) ->
                  DateTime.compare(item.end_date, today) == :gt end)
  end
end
