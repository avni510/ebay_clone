defmodule EbayClone.SessionControllerTest do
  use EbayClone.ConnCase
  import EbayClone.UserCase

  describe "new" do
    test "a page to login is displayed", %{conn: conn} do
      conn = get conn, session_path(conn, :new)

      assert html_response(conn, 200) =~ "Login"
    end
  end

  describe "create" do
    test "a user is logged in", %{conn: conn} do
      {:ok, user} = create_user("foo@example.com", "test password")

      conn = post conn,
                  session_path(conn, :create),
                  [session: %{email: user.email, password: "test password"}]

      assert redirected_to(conn) =~ item_path(conn, :index)
    end

    test "a user is notified that the wrong password was entered", %{conn: conn} do
      {:ok, user} = create_user("foo@example.com", "test password")

      conn = post conn,
                  session_path(conn, :create),
                  [session: %{email: user.email, password: "1234"}]

      assert html_response(conn, 200) =~ "Wrong email or password"
    end

    test "the user does not exist", %{conn: conn} do
      conn = post conn,
                  session_path(conn, :create),
                  [session: %{email: "invalid@example.com", password: "1234"}]

      assert html_response(conn, 200) =~ "Wrong email or password"
    end
  end

  describe "delete" do
    test "deletes the session and the user is redirected", %{conn: conn} do
      {:ok, user} = create_user("foo@example.com", "test password")
      conn = post conn,
                  session_path(conn, :create),
                  [session: %{email: user.email, password: "test password"}]
      conn = delete conn, session_path(conn, :delete)

      assert redirected_to(conn) =~ session_path(conn, :new)
      assert get_session(conn, :current_user) == nil
    end
   end
end
