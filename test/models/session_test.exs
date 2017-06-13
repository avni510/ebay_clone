defmodule EbayClone.SessionTest do
  use EbayClone.ModelCase
  use Phoenix.ConnTest

  alias EbayClone.User
  alias EbayClone.Session
  alias EbayClone.Registration
  alias EbayClone.Repo

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

  test "user is returned if the session has a current user" do
    attrs =  %{email: "foo@example.com", password: "password"}
    changeset = User.changeset(%User{}, attrs)
    Registration.create(changeset, EbayClone.Repo)
    user_id  = EbayClone.Repo.get_by(User, email: attrs[:email]).id

    conn = build_conn() |> assign(:current_user, user_id)
    user = Session.current_user(conn)

    assert "foo@example.com" == user.email
  end
end
