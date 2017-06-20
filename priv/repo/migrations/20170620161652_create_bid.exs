defmodule EbayClone.Repo.Migrations.CreateBid do
  use Ecto.Migration

  def change do
    create table(:bids) do
      add :price, :integer
      add :user_id, references(:users, on_delete: :nothing)
      add :item_id, references(:items, on_delete: :nothing)

      timestamps()
    end
    create index(:bids, [:user_id])
    create index(:bids, [:item_id])

  end
end
