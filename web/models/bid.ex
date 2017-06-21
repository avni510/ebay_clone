defmodule EbayClone.Bid do
  use EbayClone.Web, :model
  import EbayClone.PriceValidation

  alias EbayClone.Repo
  alias EbayClone.Item
  alias EbayClone.User

  schema "bids" do
    field :price, :integer
    belongs_to :user, User
    belongs_to :item, Item

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:price, :user_id, :item_id])
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:item_id)
    |> validate_required([:price, :user_id, :item_id])
    |> validate_positive_integer(:price)
    |> validate_bid_price(:price)
  end

  defp validate_bid_price(%{valid?: true} = changeset, field) do
    bid_price = get_change(changeset, field)
    item_id = get_change(changeset, :item_id)
    add_price_errors_to_changeset(changeset, field, bid_price, item_id)
  end

  defp validate_bid_price(changeset, field), do: changeset

  defp add_price_errors_to_changeset(changeset, field, bid_price, item_id) do
    if item_exists?(item_id) do
      item_current_price = Item.current_price(item_id)
      determine_errors(changeset, field, bid_price, item_current_price)
    else
      changeset
    end
  end

  defp item_exists?(item_id) do
    Repo.get(Item, item_id)
  end

  defp determine_errors(changeset, field, bid_price, item_current_price) do
    if bid_price < item_current_price do
      changeset
      |> add_error(field, "bid price cannot be less than current price")
    else
      changeset
    end
  end
end
