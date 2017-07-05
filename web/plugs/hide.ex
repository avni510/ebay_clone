defmodule EbayClone.Plugs.Hide do
  import Phoenix.Controller

  alias EbayClone.SessionInteractor
  alias EbayClone.Router.Helpers, as: Routes

  def init(default), do: default

  def call(conn, _default) do
    if SessionInteractor.logged_in?(conn) do
      conn
      |> put_flash(:error, "You are already logged in")
      |> redirect(to: Routes.item_path(conn, :index))
    else
      conn
    end
  end
end
