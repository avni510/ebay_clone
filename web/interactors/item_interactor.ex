defmodule EbayClone.ItemInteractor do
  import Ecto.Query

  alias EbayClone.Repo
  alias EbayClone.Item

  def get_items_for_user_id(user_id) do
    query = from item in Item,
      where: item.user_id == ^user_id
    Repo.all(query)
  end
end
