defmodule EbayClone.Plugs.HideTest do
  use EbayClone.ConnCase, async: true
  import EbayClone.UserCase

  alias EbayClone.Plugs.Hide

  describe "call" do
    test "if the user is logged in it redirects them to /items", %{conn: conn} do
      {:ok, user} = create_user("foo@example.com", "test password")
      conn = conn
             |> bypass_through(EbayClone.Router, :browser)
             |> get("/")
             |> assign(:current_user, user.id)
             |> Hide.call(%{})

      assert redirected_to(conn) == item_path(conn, :index)
    end

    test "if the user is not logged the connection is returned unchanged", %{conn: conn} do
      conn = get conn, registration_path(conn, :new)

      assert conn.status != 302
    end
  end
end
