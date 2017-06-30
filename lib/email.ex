defmodule EbayClone.Email do
  use Bamboo.Phoenix, view: EbayClone.EmailView

  def winner_email(email_address, item_name, winning_price) do
    new_email()
    |> to(email_address)
    |> from("avni@8thlight.com")
    |> subject("You've Won!")
    |> text_body("You've won #{item_name} with a winning price of $#{winning_price}")
  end
end
