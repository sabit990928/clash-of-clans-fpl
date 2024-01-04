defmodule ClashOfClansFpl.Standings do
  @moduledoc """
  The Standings context.
  """

  import Ecto.Query, warn: false
  alias ClashOfClansFpl.Repo

  alias ClashOfClansFpl.Standings.Team

  @doc """
  Returns the list of teams.

  ## Examples

      iex> list_teams()
      [%Team{}, ...]

  """
  def list_teams do
    Repo.all(from(t in Team, order_by: [desc: t.points, desc: t.avg_score]))
  end

  @doc """
  Gets a single team.

  Raises `Ecto.NoResultsError` if the Team does not exist.

  ## Examples

      iex> get_team!(123)
      %Team{}

      iex> get_team!(456)
      ** (Ecto.NoResultsError)

  """
  def get_team!(id), do: Repo.get!(Team, id)

  def get_team_by_fpl_id(fpl_id), do: Repo.get_by!(Team, fpl_id: fpl_id)

  @doc """
  Creates a team.

  ## Examples

      iex> create_team(%{field: value})
      {:ok, %Team{}}

      iex> create_team(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_team(attrs \\ %{}) do
    %Team{}
    |> Team.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a team.

  ## Examples

      iex> update_team(team, %{field: new_value})
      {:ok, %Team{}}

      iex> update_team(team, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_team(%Team{} = team, attrs) do
    team
    |> Team.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a team.

  ## Examples

      iex> delete_team(team)
      {:ok, %Team{}}

      iex> delete_team(team)
      {:error, %Ecto.Changeset{}}

  """
  def delete_team(%Team{} = team) do
    Repo.delete(team)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking team changes.

  ## Examples

      iex> change_team(team)
      %Ecto.Changeset{data: %Team{}}

  """
  def change_team(%Team{} = team, attrs \\ %{}) do
    Team.changeset(team, attrs)
  end

  # FPL: Clash of clans

  def get_managers_in_leagues() do
    leagues_list = [
      2_339_785,
      2_340_021,
      2_340_440,
      2_340_461,
      2_339_736,
      2_339_918,
      2_339_789,
      2_340_487,
      2_340_494,
      2_340_497,
      2_339_788,
      2_340_499,
      2_339_797,
      2_339_778,
      2_340_503,
      2_340_513,
      2_340_517,
      2_339_793,
      2_339_997,
      2_340_559
    ]

    for league_id <- leagues_list do
      single_league_managers_amount(league_id)
    end

    # https://fantasy.premierleague.com/api/leagues-classic/356774/standings/
    # https://fantasy.premierleague.com/api/leagues-classic/2340513/standings
  end

  # league_id_hq = 356_774
  def single_league_managers_amount(league_id) do
    page = 1

    league_link =
      "https://fantasy.premierleague.com/api/leagues-classic/#{league_id}/standings/?page_standings=#{page}"

    case HTTPoison.get(league_link) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        body = Jason.decode!(body)

        if length(body["standings"]["results"]) == 50 do
          manager_count =
            single_league_managers_amount(
              league_id,
              page + 1,
              50,
              body["standings"]["has_next"]
            )

          {body["league"]["name"], manager_count}
        else
          {body["league"]["name"], length(body["standings"]["results"])}
        end

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.puts("Not found :(")

      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect(reason)
    end
  end

  def single_league_managers_amount(_, _, manager_count, false = _has_next?) do
    manager_count
  end

  def single_league_managers_amount(league_id, page, manager_count, true = _has_next?) do
    league_link =
      "https://fantasy.premierleague.com/api/leagues-classic/#{league_id}/standings/?page_standings=#{page}"

    body = poison_request(league_link)

    manager_count = manager_count + length(body["standings"]["results"])
    has_next_page? = body["standings"]["has_next"]

    single_league_managers_amount(league_id, page + 1, manager_count, has_next_page?)
  end

  def poison_request(link) do
    case HTTPoison.get(link) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        Jason.decode!(body)

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.puts("Not found :(")

      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect(reason)
    end
  end

  # Float.round/1

  def calculate_all_average_league_points(gameweek) do
    leagues_list = [
      2_339_785,
      2_340_021,
      2_340_440,
      2_340_461,
      2_339_736,
      2_339_918,
      2_339_789,
      2_340_487,
      2_340_494,
      2_340_497,
      2_339_788,
      2_340_499,
      2_339_797,
      2_339_778,
      2_340_503,
      2_340_513,
      2_340_517,
      2_339_793,
      2_339_997,
      2_340_559
    ]

    duplicate_manager_ids = duplicate_managers_ids()
    gameweek_average = get_average_gameweek_point(gameweek)

    for league_id <- leagues_list do
      calculate_average_league_points(
        league_id,
        gameweek,
        duplicate_manager_ids,
        gameweek_average
      )
    end
  end

  # "https://fantasy.premierleague.com/api/entry/5018161/"
  # "https://fantasy.premierleague.com/api/entry/5018161/history/"
  # https://fantasy.premierleague.com/api/fixtures/?event=18

  defp calculate_average_league_points(
         league_id,
         gameweek,
         duplicate_manager_ids,
         gameweek_average
       ) do
    page = 1

    league_link =
      "https://fantasy.premierleague.com/api/leagues-classic/#{league_id}/standings/?page_standings=#{page}"

    body = poison_request(league_link)

    has_next_page? = body["standings"]["has_next"]

    all_managers =
      get_all_managers(league_id, page + 1, body["standings"]["results"], has_next_page?)
      |> Enum.filter(fn manager -> manager["entry"] not in duplicate_manager_ids end)

    sum =
      Enum.map(all_managers, fn manager_data ->
        entry = manager_data["entry"]

        history_body =
          poison_request("https://fantasy.premierleague.com/api/entry/#{entry}/history/")

        gameweeks = history_body["current"]
        current_gameweek = Enum.find(gameweeks, fn gw -> gw["event"] == gameweek end)

        current_gameweek["points"] - current_gameweek["event_transfers_cost"]
      end)
      |> Enum.sum()

    average =
      if length(all_managers) > 0 do
        (sum / length(all_managers))
        |> round()
      else
        gameweek_average
      end

    {body["league"]["name"], body["league"]["id"], average, length(all_managers)}
  end

  defp get_all_managers(_, _, data, false = _has_next_page?) do
    data
  end

  defp get_all_managers(league_id, page, data, true = _has_next_page?) do
    league_link =
      "https://fantasy.premierleague.com/api/leagues-classic/#{league_id}/standings/?page_standings=#{page}"

    body = poison_request(league_link)

    has_next_page? = body["standings"]["has_next"]

    data = data ++ body["standings"]["results"]

    get_all_managers(league_id, page + 1, data, has_next_page?)
  end

  def play_games(gameweek) do
    _leagues_list = [
      {2_339_785, 1},
      {2_340_021, 2},
      {2_340_440, 3},
      {2_340_461, 4},
      # Brighton
      {2_339_736, 5},
      {2_339_918, 6},
      {2_339_789, 7},
      # CP
      {2_340_487, 8},
      {2_340_494, 9},
      {2_340_497, 10},
      {2_339_788, 11},
      {2_340_499, 12},
      {2_339_797, 13},
      {2_339_778, 14},
      {2_340_503, 15},
      {2_340_513, 16},
      {2_340_517, 17},
      {2_339_793, 18},
      {2_339_997, 19},
      {2_340_559, 20}
    ]

    average_league_points = calculate_all_average_league_points(gameweek)

    link = "https://fantasy.premierleague.com/api/fixtures/?event=#{gameweek}"

    fixtures = poison_request(link)

    # team_h, team_a
    for fixture <- fixtures do
      team_h_id = fixture["team_h"]
      team_a_id = fixture["team_a"]

      team_1 = get_team!(team_h_id)
      team_2 = get_team!(team_a_id)

      {_, _, team_1_avg, team_1_managers} =
        Enum.find(average_league_points, fn {_, fpl_league_id, _, _} ->
          team_1.fpl_league_id == fpl_league_id
        end)

      {_, _, team_2_avg, team_2_managers} =
        Enum.find(average_league_points, fn {_, fpl_league_id, _, _} ->
          team_2.fpl_league_id == fpl_league_id
        end)

      cond do
        team_1_avg > team_2_avg ->
          update_team(team_1, %{
            win: team_1.win + 1,
            points: team_1.points + 3,
            avg_score: team_1.avg_score + team_1_avg,
            fpl_points: team_1.fpl_points + team_1_avg,
            manager_count: team_1_managers
          })

          update_team(team_2, %{
            lose: team_2.lose + 1,
            avg_score: team_2.avg_score + team_2_avg,
            fpl_points: team_2.fpl_points + team_2_avg,
            manager_count: team_2_managers
          })

        team_1_avg < team_2_avg ->
          update_team(team_2, %{
            win: team_2.win + 1,
            points: team_2.points + 3,
            avg_score: team_2.avg_score + team_2_avg,
            fpl_points: team_2.fpl_points + team_2_avg,
            manager_count: team_2_managers
          })

          update_team(team_1, %{
            lose: team_1.lose + 1,
            avg_score: team_1.avg_score + team_1_avg,
            fpl_points: team_1.fpl_points + team_1_avg,
            manager_count: team_1_managers
          })

        # Draw
        team_1_avg == team_2_avg ->
          update_team(team_1, %{
            draw: team_1.draw + 1,
            points: team_1.points + 1,
            avg_score: team_1.avg_score + team_1_avg,
            fpl_points: team_1.fpl_points + team_1_avg,
            manager_count: team_1_managers
          })

          update_team(team_2, %{
            draw: team_2.draw + 1,
            points: team_2.points + 1,
            avg_score: team_2.avg_score + team_2_avg,
            fpl_points: team_2.fpl_points + team_2_avg,
            manager_count: team_2_managers
          })
      end

      {"#{team_1.name} #{team_1_avg} - #{team_2_avg} #{team_2.name}"}
    end
  end

  def read_from_csv() do
  end

  # implementation with csv
  def load(gameweek) do
    # TODO: check whether files names are correct
    files = [
      "../../projects/fpl_ranker/coc_artefacts/gw_#{gameweek}_final/arsenal.csv",
      "../../projects/fpl_ranker/coc_artefacts/gw_#{gameweek}_final/aston_villa.csv",
      "../../projects/fpl_ranker/coc_artefacts/gw_#{gameweek}_final/bournemouth.csv",
      "../../projects/fpl_ranker/coc_artefacts/gw_#{gameweek}_final/brentford.csv",
      "../../projects/fpl_ranker/coc_artefacts/gw_#{gameweek}_final/brighton.csv",
      "../../projects/fpl_ranker/coc_artefacts/gw_#{gameweek}_final/burnley.csv",
      "../../projects/fpl_ranker/coc_artefacts/gw_#{gameweek}_final/chelsea.csv",
      "../../projects/fpl_ranker/coc_artefacts/gw_#{gameweek}_final/crystal_palace.csv",
      "../../projects/fpl_ranker/coc_artefacts/gw_#{gameweek}_final/everton.csv",
      "../../projects/fpl_ranker/coc_artefacts/gw_#{gameweek}_final/fulham.csv",
      "../../projects/fpl_ranker/coc_artefacts/gw_#{gameweek}_final/liverpool.csv",
      "../../projects/fpl_ranker/coc_artefacts/gw_#{gameweek}_final/luton_town.csv",
      "../../projects/fpl_ranker/coc_artefacts/gw_#{gameweek}_final/man_city.csv",
      "../../projects/fpl_ranker/coc_artefacts/gw_#{gameweek}_final/man_united.csv",
      "../../projects/fpl_ranker/coc_artefacts/gw_#{gameweek}_final/newcastle.csv",
      "../../projects/fpl_ranker/coc_artefacts/gw_#{gameweek}_final/nott_m_forest.csv",
      "../../projects/fpl_ranker/coc_artefacts/gw_#{gameweek}_final/sheffield_utd.csv",
      "../../projects/fpl_ranker/coc_artefacts/gw_#{gameweek}_final/tottenham.csv",
      "../../projects/fpl_ranker/coc_artefacts/gw_#{gameweek}_final/west_ham.csv",
      "../../projects/fpl_ranker/coc_artefacts/gw_#{gameweek}_final/wolves.csv"
    ]

    # file = "../../projects/fpl_ranker/coc_artefacts/gw_16_final/arsenal.csv"
    Enum.map(files, fn file ->
      case File.read(file) do
        {:ok, _body} ->
          file
          |> File.stream!()
          |> CSV.decode!()
          |> Enum.take(1000)
          |> Enum.drop(1)
          |> Enum.map(fn [
                           _index,
                           manager_id,
                           team_name,
                           user_name,
                           _,
                           _,
                           _,
                           _,
                           _,
                           _,
                           pure_points | _
                         ] ->
            {manager_id, team_name, pure_points, user_name}
          end)

        {:error, _} ->
          IO.puts("Couldn't open the file.")
      end
    end)
    |> List.flatten()
    |> Enum.frequencies()
    |> Map.filter(fn {_manager_data, frequency} -> frequency > 1 end)
  end

  def list_all_unique_managers do
    teams = list_teams()

    all_managers_in_leagues =
      Enum.map(teams, fn team ->
        page = 1
        league_id = team.fpl_league_id

        league_link =
          "https://fantasy.premierleague.com/api/leagues-classic/#{league_id}/standings/?page_standings=#{page}"

        body = poison_request(league_link)

        has_next_page? = body["standings"]["has_next"]

        get_all_managers(league_id, page + 1, body["standings"]["results"], has_next_page?)
        |> Enum.map(fn manager -> Map.put(manager, "league_team", team.name) end)
      end)

    unique_ids =
      all_managers_in_leagues
      |> Enum.map(fn managers ->
        Enum.map(managers, fn manager -> manager["entry"] end)
      end)
      |> List.flatten()
      |> Enum.uniq()

    Enum.map(unique_ids, fn id ->
      manager =
        Enum.find(all_managers_in_leagues |> List.flatten(), fn manager ->
          manager["entry"] == id
        end)

      {
        manager["league_team"],
        manager["player_name"],
        manager["entry_name"]
      }
    end)
    |> IO.inspect(label: "managers", limit: :infinity)
  end

  def list_duplicate_managers do
    teams = list_teams()

    Enum.map(teams, fn team ->
      page = 1
      league_id = team.fpl_league_id

      league_link =
        "https://fantasy.premierleague.com/api/leagues-classic/#{league_id}/standings/?page_standings=#{page}"

      body = poison_request(league_link)

      has_next_page? = body["standings"]["has_next"]

      get_all_managers(league_id, page + 1, body["standings"]["results"], has_next_page?)
      |> Enum.map(fn manager ->
        %{
          fpl_id: manager["entry"],
          t_name: manager["entry_name"],
          p_name: manager["player_name"]
        }
      end)
    end)
    |> List.flatten()
    |> Enum.frequencies()
    |> Map.filter(fn {_manager_data, frequency} -> frequency > 1 end)
  end

  def duplicate_managers_ids do
    list_duplicate_managers()
    |> Map.to_list()
    |> Enum.map(fn {manager, _frequency} -> manager.fpl_id end)
  end

  def reset_teams_table do
    teams = list_teams()

    for team <- teams do
      update_team(team, %{
        win: 0,
        lose: 0,
        draw: 0,
        points: 0,
        fpl_points: 0,
        manager_count: 0,
        avg_score: 0
      })
    end
  end

  def get_average_gameweek_point(gameweek) do
    link = "https://fantasy.premierleague.com/api/bootstrap-static/"

    body = poison_request(link)

    event = Enum.find(body["events"], fn event -> event["id"] == gameweek end)

    event["average_entry_score"]
  end
end

# Standings.list_duplicate_managers()
# Standings.play_games(gameweek)

# %{ 1967512, "Arzlan Kaz", "GROOOT"} => 2,
