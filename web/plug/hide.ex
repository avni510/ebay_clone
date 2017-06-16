defmodule EbayClone.Plug.Hide do
  import Plug.Conn
  import Phoenix.Controller

  alias EbayClone.Session
  alias EbayClone.Router.Helpers, as: Routes

  def init(default), do: default

  def call(conn, _default) do
    if EbayClone.Session.logged_in?(conn) do
      conn
      |> put_flash(:error, "You are already logged in")
      |> redirect(to: Routes.item_path(conn, :index))
    else
      conn
    end
  end
end
