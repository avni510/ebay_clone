defmodule EbayClone.ItemControllerTest do
  use EbayClone.ConnCase
  import EbayClone.UserCase

  alias EbayClone.Item

  def attrs_without_user_id do
    %{end_date: %{DateTime.utc_now | year: DateTime.utc_now.year + 1},
      name: "some content",
      start_price: 42}
  end

  describe "index" do
    test "lists all items" do
      {:ok, user} = create_user("foo@example.com", "test password")
      conn = build_conn() |> assign(:current_user, user.id)

      conn = get conn, item_path(conn, :index)

      assert html_response(conn, 200) =~ "Listing items"
    end
  end

  describe "new" do
    test "renders form for new item" do
      {:ok, user} = create_user("foo@example.com", "test password")
      conn = build_conn() |> assign(:current_user, user.id)

      conn = get conn, item_path(conn, :new)

      assert html_response(conn, 200) =~ "New item"
    end
  end

  describe "create" do
    test "creates item and redirects when data is valid" do
      {:ok, user} = create_user("foo@example.com", "test password")
      conn = build_conn() |> assign(:current_user, user.id)
      attrs = attrs_without_user_id()

      conn = post conn, item_path(conn, :create), item: attrs

      assert redirected_to(conn) == item_path(conn, :index)
      assert Repo.get_by(Item, name: attrs.name)
    end

    test "does not create item and renders errors when data is invalid" do
      {:ok, user} = create_user("foo@example.com", "test password")
      conn = build_conn() |> assign(:current_user, user.id)

      conn = post conn, item_path(conn, :create), item: %{}

      assert html_response(conn, 200) =~ "New item"
    end
  end

  describe "show" do
    test "shows a chosen item" do
      {:ok, user} = create_user("foo@example.com", "test password")
      conn = build_conn() |> assign(:current_user, user.id)
      valid_attrs = Map.merge(attrs_without_user_id(), %{user_id: user.id})
      item = Repo.insert! Item.changeset(%Item{}, valid_attrs)

      conn = get conn, item_path(conn, :show, item)

      assert html_response(conn, 200) =~ "Show item"
    end

    test "renders page not found when id is nonexistent" do
      {:ok, user} = create_user("foo@example.com", "test password")
      conn = build_conn() |> assign(:current_user, user.id)

      assert_error_sent 404, fn ->
        get conn, item_path(conn, :show, -1)
      end
    end
  end

  describe "edit" do
    test "renders form for editing an item" do
      {:ok, user} = create_user("foo@example.com", "test password")
      conn = build_conn() |> assign(:current_user, user.id)
      valid_attrs = Map.merge(attrs_without_user_id(), %{user_id: user.id})
      item = Repo.insert! Item.changeset(%Item{}, valid_attrs)

      conn = get conn, item_path(conn, :edit, item)

      assert html_response(conn, 200) =~ "Edit item"
    end

    test "renders page not found when id is nonexistent" do
      {:ok, user} = create_user("foo@example.com", "test password")
      conn = build_conn() |> assign(:current_user, user.id)

      assert_error_sent 404, fn ->
        get conn, item_path(conn, :edit, -1)
      end
    end
  end

  describe "update" do
    test "updates a chosen item and redirects when data is valid" do
      {:ok, user} = create_user("foo@example.com", "test password")
      conn = build_conn() |> assign(:current_user, user.id)
      valid_attrs = Map.merge(attrs_without_user_id(), %{user_id: user.id})
      item = Repo.insert! Item.changeset(%Item{}, valid_attrs)
      changed_attrs = %{valid_attrs | name: "foobar"}

      conn = put conn, item_path(conn, :update, item), %{item: changed_attrs, id: item.id}

      assert redirected_to(conn) == item_path(conn, :show, item)
      assert Repo.get_by(Item, changed_attrs)
    end
  end

  describe "delete" do
    test "deletes an item" do
      {:ok, user} = create_user("foo@example.com", "test password")
      conn = build_conn() |> assign(:current_user, user.id)
      valid_attrs = Map.merge(attrs_without_user_id(), %{user_id: user.id})
      item = Repo.insert! Item.changeset(%Item{}, valid_attrs)

      conn = delete conn, item_path(conn, :delete, item), %{id: item.id}

      assert redirected_to(conn) == item_path(conn, :index)
      refute Repo.get(Item, item.id)
    end
  end

  describe "user_items_index" do
    test "it displays all items for a user" do
      {:ok, user1} = create_user("foo@example.com", "test password")
      {:ok, user2} = create_user("bar@example.com", "password")
      conn = build_conn() |> assign(:current_user, user1.id)
      user1_attrs = Map.merge(attrs_without_user_id(), %{user_id: user1.id})
      Repo.insert! Item.changeset(%Item{}, user1_attrs)
      user2_attrs = %{attrs_without_user_id() | name: "new content"}
      user2_attrs = Map.merge(user2_attrs, %{user_id: user2.id})
      Repo.insert! Item.changeset(%Item{}, user2_attrs)

      conn = get conn, item_path(conn, :user_items_index)

      assert html_response(conn, 200) =~ "Listing items"
      assert html_response(conn, 200) =~ "some content"
    end
  end
end
