defmodule EbayClone.UserCase do

  alias EbayClone.User
  alias EbayClone.Registration
  alias EbayClone.Repo

  def create_user(email, password) do
    attrs =  %{email: email, password: password}
    changeset = User.changeset(%User{}, attrs)
    Registration.create(changeset, Repo)
  end
end

