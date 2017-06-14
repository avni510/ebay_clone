defmodule EbayClone.SessionControllerTest do
  use EbayClone.ConnCase

  alias EbayClone.Registration
  alias EbayClone.Repo
  alias EbayClone.User

  describe "new" do
    test "a page to login is displayed" do
      conn = get build_conn(), "/"

      assert html_response(conn, 200) =~ "Login"
    end
  end

  describe "create" do
    test "a user is logged in" do
      attrs =  %{email: "foo@example.com", password: "password"}
      changeset = User.changeset(%User{}, attrs)
      Registration.create(changeset, Repo)
      conn = post build_conn(), "/", [session: %{email: "foo@example.com", password: "password"}]

      assert redirected_to(conn) =~ "/"
    end

    test "a user is notified that the wrong password was entered" do
      attrs =  %{email: "foo@example.com", password: "password"}
      changeset = User.changeset(%User{}, attrs)
      Registration.create(changeset, Repo)
      conn = post build_conn(), "/", [session: %{email: "foo@example.com", password: "1234"}]

      assert html_response(conn, 200) =~ "Wrong email or password"
    end

    test "the user does not exist" do
      conn = post build_conn(), "/", [session: %{email: "invalid@example.com", password: "1234"}]

      assert html_response(conn, 200) =~ "Wrong email or password"
    end
  end

  # describe "delete" do
  #   test "deletes the session and the user is redirected" do
  #     conn = delete build_conn() |> assign(:current_user, 1), "/logout"

  #     Session.delete(conn)

  #     assert redirected_to(conn) =~ "/"
  #   end
  # end
end
