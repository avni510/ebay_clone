defmodule EbayClone.SessionTest do
  use EbayClone.ModelCase
  use Phoenix.ConnTest
  import EbayClone.UserCase

  alias EbayClone.Session
  alias EbayClone.Repo

  describe "login" do
    test "a user is returned if the user exists and the password matches" do
      {:ok, registered_user} = create_user("foo@example.com", "test password")
      params =  %{"email" => registered_user.email, "password" => "test password"}

      {:ok, current_user} = Session.login(params, Repo)

      assert current_user.email == registered_user.email
    end

    test "an error is returned if the user exists and the password does not match" do
      {:ok, registered_user} = create_user("foo@example.com", "test password")
      params =  %{"email" => registered_user.email, "password" => "1234"}

      assert :error == Session.login(params, Repo)
    end

    test "an error is returned if the user does not exist" do
      create_user("foo@example.com", "test password")
      params =  %{"email" => "bar@example.com", "password" => "1234"}

      assert :error == Session.login(params, Repo)
    end
  end

  describe "current_user" do
    test "user is returned if the session has a current user" do
      {:ok, registered_user} = create_user("foo@example.com", "test password")
      conn = build_conn() |> assign(:current_user, registered_user.id)

      current_user = Session.current_user(conn)

      assert current_user.email == registered_user.email
    end

    test "nil is returned if the session has no current user" do
      conn = build_conn() |> Plug.Session.call(Plug.Session.init([store: :cookie, key: "ok", signing_salt: "1"]))

      current_user = Session.current_user(conn)

      assert current_user == nil
    end
  end

  describe "logged_in?" do
    test "returns true if the user is logged in" do
      {:ok, registered_user} = create_user("foo@example.com", "test password")
      conn = build_conn() |> assign(:current_user, registered_user.id)

      result = Session.logged_in?(conn)

      assert result == true
    end

    test "returns false if the user is not logged in" do
      conn = build_conn() |> Plug.Session.call(Plug.Session.init([store: :cookie, key: "ok", signing_salt: "1"]))

      result = Session.logged_in?(conn)

      assert result == false
    end
  end
end
