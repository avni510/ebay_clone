defmodule EbayClone.UserInteractorTest do
  use EbayClone.ModelCase

  alias EbayClone.UserInteractor
  alias EbayClone.User
  alias EbayClone.Repo

  describe "create" do
    test "the password is hashed and stored in the crypted password field" do
      attrs =  %{email: "foo@example.com", password: "password"}
      changeset = User.changeset(%User{}, attrs)

      {:ok, user} = UserInteractor.register(changeset, Repo)

      refute nil == user.crypted_password
    end


    test "a user is saved" do
      attrs =  %{email: "foo@example.com", password: "password"}
      changeset = User.changeset(%User{}, attrs)

      UserInteractor.register(changeset, Repo)

      assert Repo.aggregate(User, :count, :id) == 1
    end
  end
end
