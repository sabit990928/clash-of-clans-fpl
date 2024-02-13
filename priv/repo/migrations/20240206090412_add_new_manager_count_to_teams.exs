defmodule ClashOfClansFpl.Repo.Migrations.AddNewManagerCountToTeams do
  use Ecto.Migration

  def change do
    alter table(:teams) do
      add :new_manager_count, :integer, default: 0
    end
  end
end
