defmodule EbayClone.Plug.Authenticate do
  import Plug.Conn
  import Phoenix.Controller

  alias EbayClone.Router.Helpers, as: Routes

  def init(default), do: default

  def call(conn, _default) do
    if EbayClone.Session.logged_in?(conn) do
      assign(conn, :current_user, EbayClone.Session.current_user(conn).id)
    else
      conn
        |> put_flash(:error, "You need to be signed in to view this page")
        |> redirect(to: Routes.session_path(conn, :new))
    end
  end
end
