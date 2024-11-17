defmodule ClashOfClansFpl.Managers.Manager do
  use Ecto.Schema
  import Ecto.Changeset

  schema "managers" do
    field :name, :string
    field :gameweek, :integer
    field :team_name, :string
    field :league_id, :integer
    field :team_id, :integer
    field :league_name, :string
    field :mvp?, :boolean, default: false
    field :gw_points, :integer
    field :gw_rank, :integer
    field :overall_rank, :integer
    field :season, :string, default: "24/25"

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(manager, attrs) do
    manager
    |> cast(attrs, [
      :gameweek,
      :team_name,
      :name,
      :league_id,
      :team_id,
      :league_name,
      :mvp?,
      :gw_points,
      :gw_rank,
      :overall_rank,
      :season
    ])
    |> validate_required([
      :gameweek,
      :team_name,
      :name,
      :league_id,
      :team_id,
      :league_name,
      :season
    ])
  end
end
