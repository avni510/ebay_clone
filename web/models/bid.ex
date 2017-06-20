defmodule EbayClone.Bid do
  use EbayClone.Web, :model
  import EbayClone.PriceValidation

  schema "bids" do
    field :price, :integer
    belongs_to :user, EbayClone.User
    belongs_to :item, EbayClone.Item

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:price, :user_id, :item_id])
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:item_id)
    |> validate_required([:price, :user_id, :item_id])
    |> validate_positive_integer(:price)
  end
end
