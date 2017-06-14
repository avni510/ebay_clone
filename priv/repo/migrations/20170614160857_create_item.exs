defmodule EbayClone.Repo.Migrations.CreateItem do
  use Ecto.Migration

  def change do
    create table(:items) do
      add :name, :string
      add :description, :string
      add :start_price, :integer
      add :end_date, :utc_datetime
      add :user_id, references(:users, on_delete: :nothing), null: false

      timestamps()
    end
    create unique_index(:items, [:name])
    create index(:items, [:user_id])

  end
end
