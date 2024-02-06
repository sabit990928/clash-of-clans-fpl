defmodule ClashOfClansFpl.Repo.Migrations.CreateManagers do
  use Ecto.Migration

  def change do
    create table(:managers) do
      add :gameweek, :integer
      add :team_name, :string
      add :name, :string
      add :league_id, :integer
      add :team_id, :integer
      add :league_name, :string

      timestamps(type: :utc_datetime)
    end
  end
end
