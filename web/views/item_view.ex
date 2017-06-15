defmodule EbayClone.ItemView do
  use EbayClone.Web, :view

  def filter_for_future_date(items) do
    today = Ecto.DateTime.utc
    Enum.filter(items,
                fn(item) ->
                  Ecto.DateTime.compare(item.end_date, today) == :gt end)
  end
end
