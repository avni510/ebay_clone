defmodule EbayClone.UserTest do
  use EbayClone.ModelCase

  alias EbayClone.User

  @valid_attrs %{email: "foo@example.com", password: "password"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)

    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)

    refute changeset.valid?
  end

  test "changeset is invalid if password is less than 5 characters" do
    attrs = %{@valid_attrs | password: "1"}

    assert {:password, "should be at least 5 character(s)"} in errors_on(%User{}, attrs)
  end

  test "changeset is invalid if email is already used" do
    user = User.changeset(%User{}, @valid_attrs)
    Repo.insert(user)

    user_clone = User.changeset(%User{}, @valid_attrs)

    assert {:error, changeset} = Repo.insert(user_clone)
    assert changeset.errors[:email] == {"has already been taken", []}
  end

  test "changeset is invalid if email does not include an '@' symbol" do
    attrs = %{@valid_attrs | email: "foo"}

    assert {:email, "has invalid format"} in errors_on(%User{}, attrs)
  end
end
