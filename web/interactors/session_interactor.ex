defmodule EbayClone.SessionInteractor do

  alias EbayClone.User
  alias EbayClone.Repo
  alias EbayClone.UserInteractor

  def login(params, repo) do
    user = repo.get_by(User, email: String.downcase(params["email"]))
    case UserInteractor.check_password(user, params["password"]) do
      true -> {:ok, user}
      _    -> :error
    end
  end

  def current_user(conn) do
    id = conn.assigns[:current_user] || Plug.Conn.fetch_session(conn)
         |> Plug.Conn.get_session(:current_user)
    if id, do: Repo.get(User, id)
  end

  def logged_in?(conn), do: !!current_user(conn)
end
