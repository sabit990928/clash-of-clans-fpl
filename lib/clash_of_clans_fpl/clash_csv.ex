defmodule ClashOfClansFpl.ClashCSV do
  alias ClashOfClansFpl.Fixtures.Fixture
  alias ClashOfClansFpl.Managers.Manager
  alias ClashOfClansFpl.Repo
  alias ClashOfClansFpl.Standings.Team

  import Ecto.Query

  def generate_csv_with_headers(gameweek) do
    File.mkdir("csv_data/#{Date.utc_today()}")

    generate_db_table()
    generate_db_fixtures()
    generate_db_managers()

    generate_mvp_managers(gameweek)
    generate_fixtures(gameweek)
    generate_table()
  end

  def generate_table() do
    headers = [
      "last_position",
      "current_position",
      "name",
      "manager_count",
      "new_manager_count",
      "win",
      "draw",
      "lose",
      "fpl_points",
      "gw_points",
      "points"
    ]

    teams_query =
      from(t in Team,
        where: t.season == "24/25",
        order_by: [asc: t.current_position],
        select: %{
          last_position: t.last_position,
          current_position: t.current_position,
          name: t.name,
          manager_count: t.manager_count,
          new_manager_count: t.new_manager_count,
          win: t.win,
          draw: t.draw,
          lose: t.lose,
          fpl_points: t.fpl_points,
          gw_points: t.gw_points,
          points: t.points
        }
      )

    teams = Repo.all(teams_query)

    csv_data =
      [
        headers
        | Enum.map(teams, fn team ->
            [
              team.last_position,
              team.current_position,
              team.name,
              team.manager_count,
              team.new_manager_count,
              team.win,
              team.draw,
              team.lose,
              team.fpl_points,
              team.gw_points,
              team.points
            ]
          end)
      ]

    csv_content =
      csv_data
      |> CSV.encode()
      |> Enum.to_list()

    File.write!("csv_data/#{Date.utc_today()}/table.csv", csv_content)
  end

  def generate_fixtures(gameweek) do
    headers = [
      "home_team",
      "home_pl_goals",
      "home_fpl_score",
      "away_team",
      "away_pl_goals",
      "away_fpl_score"
    ]

    fixtures_query =
      from(f in Fixture,
        where: f.season == "24/25" and f.gameweek == ^gameweek,
        select: %{
          home_team: f.team_home_name,
          home_PL_goals: f.team_h_score,
          home_FPL_score: f.team_home_score,
          away_team: f.team_away_name,
          away_PL_goals: f.team_a_score,
          away_FPL_score: f.team_away_score
        }
      )

    fixtures = Repo.all(fixtures_query)

    csv_data =
      [
        headers
        | Enum.map(fixtures, fn fixture ->
            [
              fixture.home_team,
              fixture.home_PL_goals,
              fixture.home_FPL_score,
              fixture.away_team,
              fixture.away_PL_goals,
              fixture.away_FPL_score
            ]
          end)
      ]

    csv_content =
      csv_data
      |> CSV.encode()
      |> Enum.to_list()

    File.write!("csv_data/#{Date.utc_today()}/fixtures.csv", csv_content)
  end

  def generate_mvp_managers(gameweek) do
    headers = ["name", "mvp_name", "mvp_team", "mvp_score", "mvp_rank", "overall_rank"]

    mvp_managers_query =
      from(
        t in subquery(
          from t in Team,
            join: m in Manager,
            on: t.fpl_league_id == m.league_id,
            where: m.season == "24/25" and m.gameweek == ^gameweek and m.mvp? == true,
            order_by: [desc: m.gw_points, asc: m.gw_rank, asc: m.overall_rank],
            select: %{
              name: t.name,
              mvp_name: m.name,
              mvp_team: m.team_name,
              mvp_score: m.gw_points,
              mvp_rank: m.gw_rank,
              overall_rank: m.overall_rank
            },
            distinct: t.name
        ),
        order_by: [desc: t.mvp_score, asc: t.mvp_rank, asc: t.overall_rank]
      )

    mvp_managers = Repo.all(mvp_managers_query)

    csv_data =
      [
        headers
        | Enum.map(mvp_managers, fn manager ->
            [
              manager.name,
              manager.mvp_name,
              manager.mvp_team,
              manager.mvp_score,
              manager.mvp_rank,
              manager.overall_rank
            ]
          end)
      ]

    csv_content =
      csv_data
      |> CSV.encode()
      |> Enum.to_list()

    File.write!("csv_data/#{Date.utc_today()}/mvp.csv", csv_content)
  end

  def generate_db_managers do
    headers = [
      "id",
      "gameweek",
      "team_name",
      "name",
      "league_id",
      "team_id",
      "league_name",
      "inserted_at",
      "updated_at",
      "mvp?",
      "gw_points",
      "gw_rank",
      "season",
      "overall_rank"
    ]

    managers = Repo.all(Manager)

    csv_data =
      [
        headers
        | Enum.map(managers, fn manager ->
            [
              manager.id,
              manager.gameweek,
              manager.team_name,
              manager.name,
              manager.league_id,
              manager.team_id,
              manager.league_name,
              manager.inserted_at,
              manager.updated_at,
              manager.mvp?,
              manager.gw_points,
              manager.gw_rank,
              manager.season,
              manager.overall_rank
            ]
          end)
      ]

    csv_content =
      csv_data
      |> CSV.encode()
      |> Enum.to_list()

    File.write!("csv_data/#{Date.utc_today()}/db_managers.csv", csv_content)
  end

  def generate_db_fixtures do
    headers = [
      "id",
      "team_home_id",
      "team_home_score",
      "team_home_name",
      "team_away_id",
      "team_away_score",
      "team_away_name",
      "gameweek",
      "team_h_manager_count",
      "team_a_manager_count",
      "team_h_id",
      "team_a_id",
      "inserted_at",
      "updated_at",
      "team_h_avg_hits",
      "team_a_avg_hits",
      "team_h_score",
      "team_a_score",
      "season"
    ]

    fixtures = Repo.all(Fixture)

    csv_data =
      [
        headers
        | Enum.map(fixtures, fn fixture ->
            [
              fixture.id,
              fixture.team_home_id,
              fixture.team_home_score,
              fixture.team_home_name,
              fixture.team_away_id,
              fixture.team_away_score,
              fixture.team_away_name,
              fixture.gameweek,
              fixture.team_h_manager_count,
              fixture.team_a_manager_count,
              fixture.team_h_id,
              fixture.team_a_id,
              fixture.inserted_at,
              fixture.updated_at,
              fixture.team_h_avg_hits,
              fixture.team_a_avg_hits,
              fixture.team_h_score,
              fixture.team_a_score,
              fixture.season
            ]
          end)
      ]

    csv_content =
      csv_data
      |> CSV.encode()
      |> Enum.to_list()

    File.write!("csv_data/#{Date.utc_today()}/db_fixtures.csv", csv_content)
  end

  def generate_db_table do
    headers = [
      "id",
      "name",
      "points",
      "manager_count",
      "win",
      "draw",
      "lose",
      "avg_score",
      "fpl_points",
      "fpl_id",
      "fpl_league_id",
      "inserted_at",
      "updated_at",
      "last_position",
      "current_position",
      "new_manager_count",
      "gw_points",
      "season"
    ]

    teams = Repo.all(Team)

    csv_data =
      [
        headers
        | Enum.map(teams, fn team ->
            [
              team.id,
              team.name,
              team.points,
              team.manager_count,
              team.win,
              team.draw,
              team.lose,
              team.avg_score,
              team.fpl_points,
              team.fpl_id,
              team.fpl_league_id,
              team.inserted_at,
              team.updated_at,
              team.last_position,
              team.current_position,
              team.new_manager_count,
              team.gw_points,
              team.season
            ]
          end)
      ]

    csv_content =
      csv_data
      |> CSV.encode()
      |> Enum.to_list()

    File.write!("csv_data/#{Date.utc_today()}/db_table.csv", csv_content)
  end
end
