defmodule EbayClone.Plug.HideTest do
  use EbayClone.ConnCase
  import EbayClone.UserCase

  alias EbayClone.Plug.Hide

  describe "call" do
    test "if the user is logged in return a 404", %{conn: conn} do
      {:ok, user} = create_user("foo@example.com", "test password")
      conn = conn
             |> bypass_through(EbayClone.Router, :browser)
             |> get("/")
             |> assign(:current_user, user.id)
             |> Hide.call(%{})

      assert redirected_to(conn) == item_path(conn, :index)
    end

    test "if the user is not logged the connection is returned unchanged", %{conn: conn} do
      conn = conn
             |> Plug.Session.call(Plug.Session.init([store: :cookie,
                                                     key: "ok",
                                                     signing_salt: "1"]))
             |> Hide.call(%{})

      assert conn.status != 302
    end
  end
end
