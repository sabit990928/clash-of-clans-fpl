defmodule ClashOfClansFpl.Repo.Migrations.AddAvgHitsToFixtures do
  use Ecto.Migration

  def change do
    alter table(:fixtures) do
      add :team_h_avg_hits, :float
      add :team_a_avg_hits, :float
    end
  end
end
