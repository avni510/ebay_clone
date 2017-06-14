defmodule EbayClone.Item do
  use EbayClone.Web, :model

  schema "items" do
    field :name, :string
    field :description, :string
    field :start_price, :integer
    field :end_date, Ecto.DateTime
    belongs_to :user, EbayClone.User

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :description, :start_price, :end_date, :user_id])
    |> foreign_key_constraint(:user_id)
    |> validate_required([:name, :start_price, :end_date, :user_id])
    |> unique_constraint(:name)
  end
end
