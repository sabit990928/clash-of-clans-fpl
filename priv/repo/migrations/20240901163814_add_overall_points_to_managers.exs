defmodule ClashOfClansFpl.Repo.Migrations.AddOverallPointsToManagers do
  use Ecto.Migration

  def change do
    alter table(:managers) do
      add :overall_rank, :integer
    end
  end
end
