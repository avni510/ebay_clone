defmodule EbayClone.Email do
  use Bamboo.Phoenix, view: EbayClone.EmailView

  def winner_email(email_address, item_name, winning_price) do
    new_email()
    |> to(email_address)
    |> from("avni@8thlight.com")
    |> subject("You've Won!")
    |> text_body("You've won #{item_name} with a winning price of $#{winning_price}")
  end

  def no_bids_email(email_address, item_name) do
    new_email()
    |> to(email_address)
    |> from("avni@8thlight.com")
    |> subject("No Bids On Your Item")
    |> text_body("#{item_name}'s auction period has ended, and there were no bids")
  end
end
