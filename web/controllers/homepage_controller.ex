defmodule EbayClone.HomepageController do
  use EbayClone.Web, :controller

  def sign_in(conn, _params) do
    render conn, "sign_in.html", conn: conn
  end
end
