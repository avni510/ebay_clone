defmodule EbayClone.SessionControllerTest do
  use EbayClone.ConnCase

  test "a page to login is displayed" do
    conn = get build_conn(), "/login"

    assert html_response(conn, 200) =~ "Login"
  end
end
