defmodule EbayClone.RegistrationControllerTest do
  use EbayClone.ConnCase

  describe "new" do
    test "a page to create an account is displayed", %{conn: conn} do
      conn = get conn, registration_path(conn, :new)

      assert html_response(conn, 200) =~ "Create an account"
    end
  end

  describe "create" do
    test "a user is successfully created", %{conn: conn} do
      conn = post conn,
                  registration_path(conn, :create),
                  [user: %{email: "foo@example.com", password: "password"}]

      assert redirected_to(conn) =~ item_path(conn, :index)
    end

    test "errors are displayed if a user cannot be created", %{conn: conn} do
      conn = post conn,
                  registration_path(conn, :create),
                  [user: %{email: "foo@example.com", password: "a"}]

      assert html_response(conn, 200) =~ "Unable to create account"
    end
  end
end
