defmodule EbayClone.ClockController do
  use EbayClone.Web, :controller

  def display(conn, _params) do
    render(conn, "display.html")
  end
end
