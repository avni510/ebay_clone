defmodule EbayClone.Repo.Migrations.UpdateItemsTable do
  use Ecto.Migration

  def change do
    alter table(:items) do
      add :awarded, :boolean, null: false, default: false
    end
  end
end
