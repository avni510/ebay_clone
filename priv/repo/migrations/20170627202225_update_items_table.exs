defmodule EbayClone.Repo.Migrations.UpdateItemsTable do
  use Ecto.Migration

  def change do
    alter table(:items) do
      add :is_closed, :boolean, null: false, default: false
    end
  end
end
