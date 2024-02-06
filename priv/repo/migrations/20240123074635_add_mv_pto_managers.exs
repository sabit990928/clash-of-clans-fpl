defmodule ClashOfClansFpl.Repo.Migrations.AddMVPtoManagers do
  use Ecto.Migration

  def change do
    alter table(:managers) do
      add :mvp?, :boolean, default: false
    end
  end
end
