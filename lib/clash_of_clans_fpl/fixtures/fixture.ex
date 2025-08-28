defmodule ClashOfClansFpl.Fixtures.Fixture do
  use Ecto.Schema
  import Ecto.Changeset

  schema "fixtures" do
    field :team_home_id, :integer
    field :team_home_score, :integer
    field :team_home_name, :string
    field :team_away_id, :integer
    field :team_away_score, :integer
    field :team_away_name, :string
    field :gameweek, :integer
    field :team_h_manager_count, :integer
    field :team_a_manager_count, :integer
    field :team_h_id, :id
    field :team_a_id, :id
    field :team_h_avg_hits, :float
    field :team_a_avg_hits, :float
    field :team_h_score, :integer
    field :team_a_score, :integer
    field :season, :string, default: "25/26"

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(fixture, attrs) do
    fixture
    |> cast(attrs, [
      :team_home_id,
      :team_home_score,
      :team_home_name,
      :team_away_id,
      :team_away_score,
      :team_away_name,
      :gameweek,
      :team_h_manager_count,
      :team_a_manager_count,
      :team_h_id,
      :team_a_id,
      :team_h_avg_hits,
      :team_a_avg_hits,
      :team_h_score,
      :team_a_score,
      :season
    ])
    |> validate_required([
      :team_home_id,
      # :team_home_score,
      :team_home_name,
      :team_away_id,
      # :team_away_score,
      :team_away_name,
      :gameweek,
      # :team_h_manager_count,
      # :team_a_manager_count,
      :season
    ])
  end
end

# import ClashOfClansFpl.Standings
# alias  ClashOfClansFpl.Standings

# 1:
# Standings.list_duplicate_managers

# 2:
# Standings.save_gameweek_league_managers 1

# 3:
# Standings.save_gameweek_fixtures 1

# 4:
# Standings.update_positions

# 5. Another optional:
# Standings.calculate_median_points 1

# ClashOfClansFpl.ClashCSV.generate_csv_with_headers 1

# -----
# New local

# alias  ClashOfClansFpl.Standings
# alias ClashOfClansFpl.SecondHalf

# 2:
# SecondHalf.copy_gw_managers_from_previous 38

# 3:
# SecondHalf.local_save_gameweek_fixtures 38

# 4:
# Standings.update_positions

# ClashOfClansFpl.ClashCSV.generate_csv_with_headers 38

# 5. Another optional:
# Standings.calculate_median_points 25
