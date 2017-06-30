defmodule EbayClone.CloseProcess.Close do
  import Ecto.Query

  alias EbayClone.Repo
  alias EbayClone.Item
  alias EbayClone.Bid
  alias EbayClone.Mailer
  alias EbayClone.User
  alias EbayClone.Email

  def execute do
    items_to_be_updated = Repo.all(items_to_be_awarded_query())
    Enum.map(items_to_be_updated, fn(item) -> update_item(item) end)
    twenty_four_hours = 24 * 60 * 60 * 1000
    Process.send_after(self(), :close, twenty_four_hours)
  end

  defp items_to_be_awarded_query do
    date = DateTime.utc_now()
    from item in Item,
      where: item.end_date <= ^date and
             item.is_closed == false
  end

  defp update_item(item) do
    winning_bid = get_winning_bid(item)
    changeset = Item.changeset(item, %{is_closed: true,
                                       winner_id: get_winning_user(winning_bid)})

    send_email(item, winning_bid)

    Repo.update(changeset)
  end

  defp send_email(item, winning_bid) do
    if get_winning_user(winning_bid) do
      send_winning_email(item, winning_bid)
    else
      send_no_bids_email(item)
    end
  end

  defp send_winning_email(item, winning_bid) do
    winning_user = Repo.get(User, winning_bid.user_id)
    email = Email.winner_email(winning_user.email, item.name, winning_bid.price)
    email |> Mailer.deliver_later
  end

  defp send_no_bids_email(item) do
    user = Repo.get(User, item.user_id)
    email = Email.no_bids_email(user.email, item.name)
    email |> Mailer.deliver_later
  end

  defp find_highest_bid_query(item) do
    from bid in Bid,
      where: ^item.id == bid.item_id,
      order_by: [desc: bid.price],
      limit: 1
  end

  defp get_winning_bid(item) do
    Repo.one(find_highest_bid_query(item))
  end

  defp get_winning_user(bid) do
    if bid, do: bid.user_id, else: nil
  end
end
