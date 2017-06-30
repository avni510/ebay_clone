defmodule EbayClone.EmailTest do
  use EbayClone.ConnCase, async: true

  alias EbayClone.Email

  describe "winner_email" do
    test "an email to tell the user that they have won is created" do
      email_address = "foo@example.com"
      item_name = "Test Item"
      winning_price = 5

      email = Email.winner_email(email_address, item_name, winning_price)

      assert email.text_body == "You've won Test Item with a winning price of $5"
    end
  end

  describe "no_bid_emails" do
    test "an email to tell the user that there were no bids on their item is created" do
      email_address = "foo@example.com"
      item_name = "Test Item"

      email = Email.no_bids_email(email_address, item_name)

      assert email.text_body == "Test Item's auction period has ended, and there were no bids"
    end
  end
end
