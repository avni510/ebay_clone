defmodule EbayClone.Repo.Migrations.AddWinnerToItems do
  use Ecto.Migration

  def change do
    alter table(:items) do
      add :winner_id, references(:users)
    end
  end
end
