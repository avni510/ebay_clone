defmodule EbayClone.RegistrationControllerTest do
  use EbayClone.ConnCase

  test "a page to create an account is displayed" do
    conn = get build_conn(), "/registrations/new"

    assert html_response(conn, 200) =~ "Create an account"
  end

  test "a user is successfully created" do
    conn = post build_conn(),
                "/registrations",
                [user: %{email: "foo@example.com", password: "password"}]

    assert redirected_to(conn) =~ "/registration/new"
  end

  test "errors are displayed if a user cannot be created" do
    conn = post build_conn(),
                "/registrations",
                [user: %{email: "foo@example.com", password: "a"}]

    assert html_response(conn, 200) =~ "Unable to create account"
  end
end
