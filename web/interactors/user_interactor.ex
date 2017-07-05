defmodule EbayClone.UserInteractor do
  import Ecto.Changeset, only: [put_change: 3]

  def register(changeset, repo) do
    changeset
    |> put_change(:crypted_password,
                  hashed_password(changeset.params["password"]))
    |> repo.insert()
  end

  defp hashed_password(password) do
    Comeonin.Bcrypt.hashpwsalt(password)
  end
end
