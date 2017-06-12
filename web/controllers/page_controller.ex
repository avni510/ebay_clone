defmodule EbayClone.PageController do
  use EbayClone.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
