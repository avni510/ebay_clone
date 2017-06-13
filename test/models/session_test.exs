defmodule EbayClone.SessionTest do
  use EbayClone.ModelCase

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

  test "a error is returned if the user exists and the password does not match" do
    attrs =  %{email: "foo@example.com", password: "password"}
    changeset = User.changeset(%User{}, attrs)
    Registration.create(changeset, Repo)
    params =  %{"email" => "foo@example.com", "password" => "1234"}

    assert :error == Session.login(params, Repo)
  end

  test "a error is returned if the user does not exist" do
    attrs =  %{email: "foo@example.com", password: "password"}
    changeset = User.changeset(%User{}, attrs)
    Registration.create(changeset, Repo)
    params =  %{"email" => "bar@example.com", "password" => "1234"}

    assert :error == Session.login(params, Repo)
  end
end
