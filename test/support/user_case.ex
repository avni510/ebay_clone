defmodule EbayClone.UserCase do

  alias EbayClone.User
  alias EbayClone.Repo
  alias EbayClone.UserInteractor

  def create_user(email, password) do
    attrs =  %{email: email, password: password}
    changeset = User.changeset(%User{}, attrs)
    UserInteractor.register(changeset, Repo)
  end
end

