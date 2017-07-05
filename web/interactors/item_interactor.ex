defmodule EbayClone.ItemInteractor do
  import Ecto.Query

  alias EbayClone.Repo
  alias EbayClone.Item

  def get_items_for_user_id(user_id) do
    query = from item in Item,
      where: item.user_id == ^user_id
    Repo.all(query)
  end


  def load(id) do
    case Repo.get(Item, id) do
      nil -> nil
      item -> item |> load_current_price
    end
  end

  defp load_current_price(item) do
    Map.put(item, :current_price, current_price(item))
  end

  defp current_price(item) do
    Item.current_price(item)
    |> Repo.one
    |> case do
      nil -> item.start_price
      p -> p
    end
  end
end
