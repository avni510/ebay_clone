defmodule EbayClone.HomepageControllerTest do
  use EbayClone.ConnCase
  import EbayClone.UserCase

  describe "get_homepage" do
    test "if the user is logged in it redirects them to /items", %{conn: conn} do
      {:ok, user} = create_user("foo@example.com", "test password")
      conn = conn |> assign(:current_user, user.id)

      conn = get conn, homepage_path(conn, :get_homepage)

      assert redirected_to(conn) == item_path(conn, :index)
    end

    test "if the user is not logged in it renders a landing page", %{conn: conn} do
      conn = get conn, homepage_path(conn, :get_homepage)

      assert html_response(conn, 200) =~ "Login"
      assert html_response(conn, 200) =~ "Create an Account"
    end
  end
end
