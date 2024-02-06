defmodule ClashOfClansFpl.Repo.Migrations.AddScoreToFixtures do
  use Ecto.Migration

  def change do
    alter table(:fixtures) do
      add :team_h_score, :integer
      add :team_a_score, :integer
    end
  end
end
