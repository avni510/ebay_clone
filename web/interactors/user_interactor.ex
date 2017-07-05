defmodule EbayClone.UserInteractor do
  import Ecto.Changeset, only: [put_change: 3]

  alias Comeonin.Bcrypt

  def register(changeset, repo) do
    changeset
    |> put_change(:crypted_password,
                  hashed_password(changeset.params["password"]))
    |> repo.insert()
  end

  defp hashed_password(password) do
    Bcrypt.hashpwsalt(password)
  end

  def check_password(user, password) do
    case user do
      nil -> false
      _   -> Bcrypt.checkpw(password, user.crypted_password)
    end
  end
end
