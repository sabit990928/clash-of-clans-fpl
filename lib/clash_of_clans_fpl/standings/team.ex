defmodule ClashOfClansFpl.Standings.Team do
  use Ecto.Schema
  import Ecto.Changeset

  schema "teams" do
    field :name, :string
    field :points, :integer, default: 0
    field :manager_count, :integer
    field :win, :integer, default: 0
    field :draw, :integer, default: 0
    field :lose, :integer, default: 0
    field :avg_score, :float
    field :fpl_points, :integer
    field :fpl_id, :integer
    field :fpl_league_id, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(team, attrs) do
    team
    |> cast(attrs, [
      :name,
      :points,
      :manager_count,
      :win,
      :draw,
      :lose,
      :avg_score,
      :fpl_points,
      :fpl_id,
      :fpl_league_id
    ])
    |> validate_required([
      :name,
      :points,
      :win,
      :draw,
      :lose,
      :fpl_id,
      :fpl_league_id
    ])
  end
end
