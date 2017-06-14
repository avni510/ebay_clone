defmodule EbayClone.ItemControllerTest do
  use EbayClone.ConnCase

  alias EbayClone.Item
  alias EbayClone.User
  alias EbayClone.Registration

  def create_user do
    attrs =  %{email: "foo@example.com", password: "password"}
    changeset = User.changeset(%User{}, attrs)
    Registration.create(changeset, EbayClone.Repo)
  end

  def valid_attrs do
    {:ok, user} = create_user()
    %{end_date: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010},
      name: "some content",
      start_price: 42,
      user_id: user.id}
  end

  describe "index" do
    test "lists all items", %{conn: conn} do
      conn = get conn, item_path(conn, :index)

      assert html_response(conn, 200) =~ "Listing items"
    end
  end

  describe "new" do
    test "renders form for new item", %{conn: conn} do
      conn = get conn, item_path(conn, :new)

      assert html_response(conn, 200) =~ "New item"
    end
  end

  describe "create" do
    test "creates item and redirects when data is valid", %{conn: conn} do
      attrs = valid_attrs()
      conn = post conn, item_path(conn, :create), item: attrs

      assert redirected_to(conn) == item_path(conn, :index)
      assert Repo.get_by(Item, attrs)
    end

    test "does not create item and renders errors when data is invalid", %{conn: conn} do
      conn = post conn, item_path(conn, :create), item: %{}

      assert html_response(conn, 200) =~ "New item"
    end
  end

  describe "show" do
    test "shows a chosen item", %{conn: conn} do
      item = Repo.insert! Item.changeset(%Item{}, valid_attrs())
      conn = get conn, item_path(conn, :show, item)

      assert html_response(conn, 200) =~ "Show item"
    end

    test "renders page not found when id is nonexistent", %{conn: conn} do
      assert_error_sent 404, fn ->
        get conn, item_path(conn, :show, -1)
      end
    end
  end

  describe "edit" do
    test "renders form for editing an item", %{conn: conn} do
      item = Repo.insert! Item.changeset(%Item{}, valid_attrs())
      conn = get conn, item_path(conn, :edit, item)

      assert html_response(conn, 200) =~ "Edit item"
    end

    test "renders page not found when id is nonexistent", %{conn: conn} do
      assert_error_sent 404, fn ->
        get conn, item_path(conn, :edit, -1)
      end
    end
  end

  describe "update" do
    test "updates a chosen item and redirects when data is valid", %{conn: conn} do
      attrs = valid_attrs()
      item = Repo.insert! Item.changeset(%Item{}, attrs)

      changed_attrs = %{attrs | name: "foobar"}
      conn = put conn, item_path(conn, :update, item), %{item: changed_attrs, id: item.id}

      assert redirected_to(conn) == item_path(conn, :show, item)
      assert Repo.get_by(Item, changed_attrs)
    end
  end

  describe "delete" do
    test "deletes an item", %{conn: conn} do
      attrs = valid_attrs()
      item = Repo.insert! Item.changeset(%Item{}, attrs)

      conn = delete conn, item_path(conn, :delete, item), %{id: item.id}

      assert redirected_to(conn) == item_path(conn, :index)
      refute Repo.get(Item, item.id)
    end
  end
end
