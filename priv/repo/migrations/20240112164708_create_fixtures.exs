defmodule ClashOfClansFpl.Repo.Migrations.CreateFixtures do
  use Ecto.Migration

  def change do
    create table(:fixtures) do
      add :team_home_id, :integer
      add :team_home_score, :integer
      add :team_home_name, :string
      add :team_away_id, :integer
      add :team_away_score, :integer
      add :team_away_name, :string
      add :gameweek, :integer
      add :team_h_manager_count, :integer
      add :team_a_manager_count, :integer
      add :team_h_id, references(:teams, on_delete: :nothing)
      add :team_a_id, references(:teams, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:fixtures, [:team_h_id])
    create index(:fixtures, [:team_a_id])
  end
end
