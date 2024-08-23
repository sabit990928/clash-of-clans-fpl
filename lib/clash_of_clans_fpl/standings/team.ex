defmodule ClashOfClansFpl.Standings.Team do
  use Ecto.Schema
  import Ecto.Changeset

  schema "teams" do
    field :name, :string
    field :points, :integer, default: 0
    field :manager_count, :integer
    field :new_manager_count, :integer, default: 0
    field :win, :integer, default: 0
    field :draw, :integer, default: 0
    field :lose, :integer, default: 0
    field :avg_score, :float
    field :fpl_points, :integer
    field :fpl_id, :integer
    field :fpl_league_id, :integer
    field :last_position, :integer
    field :current_position, :integer
    field :gw_points, :integer
    field :season, :string, default: "24/25"

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(team, attrs) do
    team
    |> cast(attrs, [
      :name,
      :points,
      :manager_count,
      :new_manager_count,
      :win,
      :draw,
      :lose,
      :avg_score,
      :fpl_points,
      :fpl_id,
      :fpl_league_id,
      :last_position,
      :current_position,
      :gw_points,
      :season
    ])
    |> validate_required([
      :name,
      :points,
      :win,
      :draw,
      :lose,
      :fpl_id,
      :fpl_league_id,
      :season
    ])
  end
end
