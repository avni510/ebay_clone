defmodule EbayClone.Item do
  use EbayClone.Web, :model
  import EbayClone.PriceValidation

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
