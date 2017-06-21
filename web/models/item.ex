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
    belongs_to :user, EbayClone.User

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :description, :start_price, :end_date, :user_id])
    |> foreign_key_constraint(:user_id)
    |> validate_required([:name, :start_price, :end_date, :user_id])
    |> validate_future_date(:end_date)
    |> validate_positive_integer(:start_price)
  end

  def current_price(item_id) do
    all_bid_prices = get_all_prices(item_id)
    retrieve_price(all_bid_prices, item_id)
  end

  def get_all_prices(item_id) do
    query = from bid in Bid,
      where: bid.item_id == ^item_id,
      select: bid.price
    Repo.all(query)
  end

  defp retrieve_price(all_prices, item_id) do
    if Enum.empty?(all_prices) do
      item = Repo.get(__MODULE__, item_id)
      item.start_price
    else
      Enum.max(all_prices)
    end
  end

  defp validate_future_date(%{changes: changes} = changeset, field) do
    if date = changes[field] do
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
