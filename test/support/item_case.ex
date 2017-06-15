defmodule EbayClone.ItemCase do
  import EbayClone.UserCase

  alias EbayClone.Item
  alias EbayClone.Repo

  def create_item(email, password, end_date, name, description, start_price) do
    {:ok, user} = create_user(email, password)
    attrs = %{end_date: end_date,
              name: name,
              description: description,
              start_price: start_price,
              user_id: user.id}

    changeset = Item.changeset(%Item{}, attrs)
    Repo.insert(changeset)
  end
end
