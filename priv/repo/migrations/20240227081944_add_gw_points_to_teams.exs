defmodule ClashOfClansFpl.Repo.Migrations.AddGwPointsToTeams do
  use Ecto.Migration

  def change do
    alter table(:teams) do
      add :gw_points, :integer
    end
  end
end
