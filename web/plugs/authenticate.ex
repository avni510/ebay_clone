defmodule EbayClone.Plugs.Authenticate do
  import Plug.Conn
  import Phoenix.Controller

  alias EbayClone.SessionInteractor
  alias EbayClone.Router.Helpers, as: Routes

  def init(default), do: default

  def call(conn, _default) do
    if SessionInteractor.logged_in?(conn) do
      assign(conn, :current_user, SessionInteractor.current_user(conn).id)
    else
      conn
      |> put_flash(:error, "You need to be signed in to view this page")
      |> redirect(to: Routes.session_path(conn, :new))
      |> halt
    end
  end
end
