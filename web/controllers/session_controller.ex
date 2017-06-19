defmodule EbayClone.SessionController do
  use EbayClone.Web, :controller

  def new(conn, _params) do
    render conn, "new.html"
  end

  def create(conn, %{"session" => session_params}) do
    case EbayClone.Session.login(session_params, EbayClone.Repo) do
      {:ok, user} ->
        conn
        |> put_session(:current_user, user.id)
        |> put_flash(:info, "Logged in")
        |> redirect(to: item_path(conn, :index))
      :error ->
        conn
        |> put_flash(:info, "Wrong email or password")
        |> render("new.html")
    end
  end

  def delete(conn, _params) do
    conn
    |> delete_session(:current_user)
    |> put_flash(:info, "Logged out")
    |> redirect(to: homepage_path(conn, :get_homepage))
  end
end
