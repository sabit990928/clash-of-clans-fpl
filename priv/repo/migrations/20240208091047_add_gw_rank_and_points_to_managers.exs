defmodule ClashOfClansFpl.Repo.Migrations.AddGwRankAndPointsToManagers do
  use Ecto.Migration

  def change do
    alter table(:managers) do
      add :gw_points, :integer
      add :gw_rank, :integer
    end
  end
end
