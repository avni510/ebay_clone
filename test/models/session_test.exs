defmodule EbayClone.SessionTest do
  use EbayClone.ModelCase
  use Phoenix.ConnTest

  alias EbayClone.User
  alias EbayClone.Session
  alias EbayClone.Registration
  alias EbayClone.Repo

  describe "login" do
    test "a user is returned if the user exists and the password matches" do
      attrs =  %{email: "foo@example.com", password: "password"}
      changeset = User.changeset(%User{}, attrs)
      Registration.create(changeset, Repo)
      params =  %{"email" => "foo@example.com", "password" => "password"}

      {:ok, user} = Session.login(params, Repo)

      assert user.email == "foo@example.com"
    end

    test "an error is returned if the user exists and the password does not match" do
      attrs =  %{email: "foo@example.com", password: "password"}
      changeset = User.changeset(%User{}, attrs)
      Registration.create(changeset, Repo)
      params =  %{"email" => "foo@example.com", "password" => "1234"}

      assert :error == Session.login(params, Repo)
    end

    test "an error is returned if the user does not exist" do
      attrs =  %{email: "foo@example.com", password: "password"}
      changeset = User.changeset(%User{}, attrs)
      Registration.create(changeset, Repo)
      params =  %{"email" => "bar@example.com", "password" => "1234"}

      assert :error == Session.login(params, Repo)
    end
  end

  describe "current_user" do
    test "user is returned if the session has a current user" do
      attrs =  %{email: "foo@example.com", password: "password"}
      changeset = User.changeset(%User{}, attrs)
      Registration.create(changeset, EbayClone.Repo)
      user_id  = EbayClone.Repo.get_by(User, email: attrs[:email]).id
      conn = build_conn() |> assign(:current_user, user_id)

      user = Session.current_user(conn)

      assert "foo@example.com" == user.email
    end

    test "nil is returned if the session has no current user" do
      conn = build_conn() |> Plug.Session.call(Plug.Session.init([store: :cookie, key: "ok", signing_salt: "1"]))

      user = Session.current_user(conn)

      assert nil == user
    end
  end

  describe "logged_in?" do
    test "returns true if the user is logged in" do
      attrs =  %{email: "foo@example.com", password: "password"}
      changeset = User.changeset(%User{}, attrs)
      Registration.create(changeset, EbayClone.Repo)
      user_id  = EbayClone.Repo.get_by(User, email: attrs[:email]).id
      conn = build_conn() |> assign(:current_user, user_id)

      result = Session.logged_in?(conn)

      assert true == result
    end

    test "returns false if the user is not logged in" do
      conn = build_conn() |> Plug.Session.call(Plug.Session.init([store: :cookie, key: "ok", signing_salt: "1"]))

      result = Session.logged_in?(conn)

      assert false == result
    end
  end

end
