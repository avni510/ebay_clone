defmodule EbayClone.EmailTest do
  use EbayClone.ConnCase, async: true

  alias EbayClone.Email

  describe "winner_email" do
    test "an email is created" do
      email_address = "foo@example.com"
      item_name = "Test Item"
      winning_price = 5

      email = Email.winner_email(email_address, item_name, winning_price)

      assert email.text_body == "You've won Test Item with a winning price of $5"
    end
  end
end
