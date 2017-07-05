defmodule EbayClone.HomepageController do
  use EbayClone.Web, :controller

  alias EbayClone.SessionInteractor

  def get_homepage(conn, _params)  do
    if SessionInteractor.logged_in?(conn) do
      redirect(conn, to: item_path(conn, :index))
    else
      conn
      |> put_layout(false)
      |> render("landing_page.html")
    end
  end
end
