defmodule ClashOfClansFpl.Repo.Migrations.AddPositionToTeams do
  use Ecto.Migration

  def change do
    alter table(:teams) do
      add :last_position, :integer
      add :current_position, :integer
    end
  end
end
