defmodule EbayClone.RegistrationTest do
  use EbayClone.ModelCase

  alias EbayClone.Registration
  alias EbayClone.User
  alias EbayClone.Repo

  describe "create" do
    test "the password is hashed and stored in the crypted password field" do
      attrs =  %{email: "foo@example.com", password: "password"}
      changeset = User.changeset(%User{}, attrs)

      {:ok, user} = Registration.create(changeset, Repo)

      refute nil == user.crypted_password
    end


    test "a user is saved" do
      attrs =  %{email: "foo@example.com", password: "password"}
      changeset = User.changeset(%User{}, attrs)

      Registration.create(changeset, Repo)

      assert Repo.aggregate(User, :count, :id) == 1
    end
  end
end
