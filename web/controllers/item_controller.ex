defmodule EbayClone.ItemController do
  use EbayClone.Web, :controller

  alias EbayClone.Item
  alias EbayClone.ItemInteractor
  alias EbayClone.Session

  def index(conn, _params) do
    items = Repo.all(Item)
    render(conn, "index.html", items: items)
  end

  def new(conn, _params) do
    changeset = Item.changeset(%Item{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"item" => item_params}) do
    current_user = Session.current_user(conn)
    params_with_user_id = Map.merge(item_params, %{"user_id" => current_user.id})
    changeset = Item.changeset(%Item{}, params_with_user_id)

    case Repo.insert(changeset) do
      {:ok, _item} ->
        conn
        |> put_flash(:info, "Item created successfully.")
        |> redirect(to: item_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    item = Repo.get!(Item, id)
    render(conn, "show.html", item: item)
  end

  def edit(conn, %{"id" => id}) do
    item = Repo.get!(Item, id)
    changeset = Item.changeset(item)
    render(conn, "edit.html", item: item, changeset: changeset)
  end

  def update(conn, %{"id" => id, "item" => item_params}) do
    item = Repo.get!(Item, id)
    changeset = Item.changeset(item, item_params)
    Repo.update(changeset)
    conn
    |> put_flash(:info, "Item updated successfully.")
    |> redirect(to: item_path(conn, :show, item))
  end

  def delete(conn, %{"id" => id}) do
    item = Repo.get!(Item, id)
    Repo.delete!(item)

    conn
    |> put_flash(:info, "Item deleted successfully.")
    |> redirect(to: item_path(conn, :index))
  end

  def user_items_index(conn, _params) do
    user = Session.current_user(conn)
    items = ItemInteractor.get_items_for_user_id(user.id)
    render(conn, "index.html", items: items)
  end
end
