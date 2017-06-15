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
        |> redirect(to: "/items")
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
    |> redirect(to: "/")
  end

  # defp delete_current_session(conn) do
  #   if conn.assigns[:current_user] do
  #     conn.assign(conn, :current_user, nil)
  #   else
  #     delete_session(conn, :current_user)
  #   end
  # end
end
