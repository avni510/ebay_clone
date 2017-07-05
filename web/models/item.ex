defmodule EbayClone.Item do
  use EbayClone.Web, :model
  import Ecto.Query
  import EbayClone.PriceValidation

  alias EbayClone.Repo
  alias EbayClone.Bid

  schema "items" do
    field :name, :string
    field :description, :string
    field :start_price, :integer
    field :end_date, :utc_datetime
    field :is_closed, :boolean
    field :current_price, :integer, virtual: true
    belongs_to :user, EbayClone.User
    belongs_to :winner, EbayClone.User
    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> set_default_is_closed_flag
    |> cast(params, [:name, :description, :start_price, :end_date, :user_id, :is_closed, :winner_id])
    |> foreign_key_constraint(:user_id)
    |> validate_required([:name, :start_price, :end_date, :user_id, :is_closed])
    |> validate_future_date(:end_date)
    |> validate_positive_integer(:start_price)
    |> foreign_key_constraint(:winner_id)
  end

  def current_price(%__MODULE__{} = item) do
    max_bid_price(item.id)
  end

  def current_price(item_id) do
    max_bid_price = get_max_price(item_id)
    retrieve_price(max_bid_price, item_id)
  end

  defp get_max_price(item_id) do
    max_bid_price(item_id)
    |> Repo.one
  end

  defp max_bid_price(item_id) do
    from bid in Bid,
      where: bid.item_id == ^item_id,
      select: max(bid.price)
  end

  defp set_default_is_closed_flag(struct) do
    %{struct | is_closed: false}
  end

  defp retrieve_price(max_bid_price, item_id) do
    if max_bid_price do
      max_bid_price
    else
      item = Repo.get(__MODULE__, item_id)
      item.start_price
    end
  end

  defp validate_future_date(changeset, field) do
    date = get_change(changeset, field)
    if date do
      add_date_errors_to_changeset(changeset, field, date)
    else
      changeset
    end
  end

  defp add_date_errors_to_changeset(changeset, field, date) do
    today = DateTime.utc_now()
    if DateTime.compare(date, today) == :lt do
      changeset
      |> add_error(field, "can't be a date in the past")
    else
      changeset
    end
  end
end
