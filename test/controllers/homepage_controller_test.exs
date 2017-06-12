defmodule EbayClone.HomepageControllerTest do
  use EbayClone.ConnCase

  test "a sign in page is displayed" do
    conn = get build_conn(), "/"
    assert html_response(conn, 200) =~ "Sign In"
  end
end
