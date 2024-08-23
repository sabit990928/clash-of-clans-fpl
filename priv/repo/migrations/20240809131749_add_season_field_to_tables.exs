defmodule ClashOfClansFpl.Repo.Migrations.AddSeasonFieldToTables do
  use Ecto.Migration

  def change do
    alter table(:teams) do
      add :season, :string, default: "23/24"
    end

    alter table(:fixtures) do
      add :season, :string, default: "23/24"
    end

    alter table(:managers) do
      add :season, :string, default: "23/24"
    end
  end
end
