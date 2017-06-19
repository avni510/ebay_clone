defmodule EbayClone.Plug.AuthenticateTest do
  use EbayClone.ConnCase
  import EbayClone.UserCase

  alias EbayClone.Plug.Authenticate

  describe "call" do
    test "if a user is logged in then a connection with the user id is stored in memory", %{conn: conn} do
      {:ok, user} = create_user("foo@example.com", "test password")
      conn = conn
             |> assign(:current_user, user.id)
             |> Authenticate.call(%{})

      assert conn.assigns[:current_user] == user.id
    end

    test "if a user is not logged in then the user is redirected to the login page", %{conn: conn} do
      conn = get conn, item_path(conn, :index)

      assert redirected_to(conn) == session_path(conn, :new)
    end
  end
end
