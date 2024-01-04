defmodule ClashOfClansFpl.Repo.Migrations.CreateTeams do
  use Ecto.Migration

  def change do
    create table(:teams) do
      add :name, :string
      add :points, :integer
      add :manager_count, :integer
      add :win, :integer
      add :draw, :integer
      add :lose, :integer
      add :avg_score, :float
      add :fpl_points, :integer
      add :fpl_id, :integer
      add :fpl_league_id, :integer

      timestamps(type: :utc_datetime)
    end
  end
end
