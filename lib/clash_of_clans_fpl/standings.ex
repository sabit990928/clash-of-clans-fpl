defmodule ClashOfClansFpl.Standings do
  @moduledoc """
  The Standings context.
  """

  import Ecto.Query, warn: false

  alias ClashOfClansFpl.Fixtures
  alias ClashOfClansFpl.Repo
  alias ClashOfClansFpl.Standings.Team

  @doc """
  Returns the list of teams.

  ## Examples

      iex> list_teams("23/24")
      [%Team{}, ...]

  """
  def list_teams(season \\ "25/26") do
    Repo.all(
      from(t in Team,
        where: t.season == ^season,
        order_by: [desc: t.points, desc: t.fpl_points, asc: t.manager_count]
      )
    )
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

  @doc """

  """
  def get_team_by_fpl_id(fpl_id, season \\ "25/26"),
    do: Repo.get_by!(Team, fpl_id: fpl_id, season: season)

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
    # leagues_list = [
    #   2_339_785,
    #   2_340_021,
    #   2_340_440,
    #   2_340_461,
    #   2_339_736,
    #   2_339_918,
    #   2_339_789,
    #   2_340_487,
    #   2_340_494,
    #   2_340_497,
    #   2_339_788,
    #   2_340_499,
    #   2_339_797,
    #   2_339_778,
    #   2_340_503,
    #   2_340_513,
    #   2_340_517,
    #   2_339_793,
    #   2_339_997,
    #   2_340_559
    # ]

    leagues_list = [
      652_660,
      652_668,
      652_669,
      652_670,
      652_656,
      652_802,
      652_663,
      652_671,
      652_672,
      652_674,
      652_662,
      652_765,
      652_665,
      652_658,
      652_677,
      652_679,
      652_719,
      652_664,
      652_667,
      652_681
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

  @doc """
  Step 2. Run for manually saving managers.
  Runs from the console.
  """
  @spec save_gameweek_league_managers(integer()) :: atom()
  def save_gameweek_league_managers(gameweek) do
    # Manually update every new season
    leagues_list = list_teams("25/26") |> Enum.map(& &1.fpl_league_id)

    duplicate_manager_ids = duplicate_managers_ids()
    # Maybe add filter for manually blocked managers

    for league_id <- leagues_list do
      page = 1

      league_link =
        "https://fantasy.premierleague.com/api/leagues-classic/#{league_id}/standings/?page_standings=#{page}"

      body = poison_request(league_link)

      has_next_page? = body["standings"]["has_next"]

      _all_managers =
        get_all_managers(league_id, page + 1, body["standings"]["results"], has_next_page?)
        |> Enum.filter(fn manager -> manager["entry"] not in duplicate_manager_ids end)
        |> Enum.map(fn manager ->
          alias ClashOfClansFpl.Managers

          Managers.create_manager(%{
            name: manager["player_name"],
            gameweek: gameweek,
            team_name: manager["entry_name"],
            league_id: league_id,
            team_id: manager["entry"],
            league_name: body["league"]["name"],
            # Manually update every new season
            season: "25/26"
          })
        end)

      :ok
    end
  end

  def calculate_all_average_league_points(gameweek) do
    # Manually update every new season
    leagues_list = list_teams("25/26") |> Enum.map(& &1.fpl_league_id)

    # Get duplicated ones and blocked/blacklist managers.
    # Maybe need to create separate function for blacklist managers.
    duplicate_manager_ids =
      duplicate_managers_ids()

    # It's for the manual blacklist in the season 23/24.
    # Maybe put down his name or update his ID for season 24/25.
    # |> List.insert_at(-1, "1430773")

    # That blocked ID is 4526480 in 24/25 season. Murad Farzaliyev

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

  @doc """
  Handles one of the main logic on average league
  points calculation. Simple average divide is for now.
  """
  def calculate_average_league_points(
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

    managers_current_gw =
      Enum.map(all_managers, fn manager_data ->
        entry = manager_data["entry"]

        history_body =
          poison_request("https://fantasy.premierleague.com/api/entry/#{entry}/history/")

        gameweeks = history_body["current"]
        {manager_data["entry"], Enum.find(gameweeks, fn gw -> gw["event"] == gameweek end)}
      end)

    sorted_managers =
      Enum.map(managers_current_gw, fn {name, current_gameweek} ->
        {name, current_gameweek["points"] - current_gameweek["event_transfers_cost"],
         current_gameweek["rank"], current_gameweek["overall_rank"]}
      end)
      |> Enum.sort_by(fn {_id, pure_points, _GWR, _OR} -> pure_points end, :desc)

    # Get the highest point in the league

    max_points =
      case sorted_managers do
        [] -> gameweek_average
        [{_id, points, _GWR, _OR} | _] -> points
      end

    # Get all managers with the highest points
    all_mvp_managers =
      Enum.filter(sorted_managers, fn {_id, points, _GWR, _OR} -> points == max_points end)

    # maybe refactor that logic
    Enum.each(all_mvp_managers, fn {fpl_id, points, gameweek_rank, overall_rank} ->
      alias ClashOfClansFpl.Managers

      manager =
        from(m in Managers.Manager, where: m.team_id == ^fpl_id and m.gameweek == ^gameweek)
        |> Repo.one()

      Managers.update_manager(manager, %{
        mvp?: true,
        gw_points: points,
        gw_rank: gameweek_rank,
        overall_rank: overall_rank
      })
    end)

    sum =
      Enum.map(managers_current_gw, fn {_id, current_gameweek} ->
        current_gameweek["points"] - current_gameweek["event_transfers_cost"]
      end)
      |> Enum.sum()

    hits_sum =
      Enum.map(managers_current_gw, fn {_id, current_gameweek} ->
        current_gameweek["event_transfers_cost"]
      end)
      |> Enum.sum()

    average =
      if length(all_managers) > 0 do
        (sum / length(all_managers))
        |> round()
      else
        gameweek_average
      end

    hits_average =
      if length(all_managers) > 0 && hits_sum !== 0 do
        hits_sum / length(all_managers)
      else
        0
      end

    {body["league"]["name"], body["league"]["id"], average, length(all_managers), hits_average}
  end

  # Write implementation here
  # defp get_new_managers(_, _, data, false = _has_next_page?) do
  #   data
  # end

  # defp get_new_managers(league_id, page, data, true = _has_next_page?) do
  #   league_link =
  #     "https://fantasy.premierleague.com/api/leagues-classic/#{league_id}/standings/?page_standings=#{page}"

  #   body = poison_request(league_link)

  #   has_next_page? = body["standings"]["has_next"]

  #   data = data ++ body["standings"]["results"]

  #   get_all_managers(league_id, page + 1, data, has_next_page?)
  # end

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

  @doc """
  Step 4.
  Update teams table.
  """
  def play_games(gameweek) do
    average_league_points = calculate_all_average_league_points(gameweek)

    link = "https://fantasy.premierleague.com/api/fixtures/?event=#{gameweek}"

    # TODO: maybe get fixtures from generated fixtures?

    fixtures = poison_request(link)

    # team_h, team_a
    for fixture <- fixtures do
      team_h_id = fixture["team_h"]
      team_a_id = fixture["team_a"]

      team_1 = get_team_by_fpl_id(team_h_id)
      team_2 = get_team_by_fpl_id(team_a_id)

      {_, _, team_1_avg, team_1_managers, _} =
        Enum.find(average_league_points, fn {_, fpl_league_id, _, _, _} ->
          team_1.fpl_league_id == fpl_league_id
        end)

      {_, _, team_2_avg, team_2_managers, _} =
        Enum.find(average_league_points, fn {_, fpl_league_id, _, _, _} ->
          team_2.fpl_league_id == fpl_league_id
        end)

      cond do
        team_1_avg > team_2_avg ->
          update_team(team_1, %{
            win: team_1.win + 1,
            points: team_1.points + 3,
            avg_score: team_1.avg_score + team_1_avg,
            fpl_points: team_1.fpl_points + team_1_avg,
            manager_count: team_1_managers,
            new_manager_count: team_1_managers - team_1.manager_count,
            gw_points: team_1_avg
          })

          update_team(team_2, %{
            lose: team_2.lose + 1,
            avg_score: team_2.avg_score + team_2_avg,
            fpl_points: team_2.fpl_points + team_2_avg,
            manager_count: team_2_managers,
            new_manager_count: team_2_managers - team_2.manager_count,
            gw_points: team_2_avg
          })

        team_1_avg < team_2_avg ->
          update_team(team_2, %{
            win: team_2.win + 1,
            points: team_2.points + 3,
            avg_score: team_2.avg_score + team_2_avg,
            fpl_points: team_2.fpl_points + team_2_avg,
            manager_count: team_2_managers,
            new_manager_count: team_2_managers - team_2.manager_count,
            gw_points: team_2_avg
          })

          update_team(team_1, %{
            lose: team_1.lose + 1,
            avg_score: team_1.avg_score + team_1_avg,
            fpl_points: team_1.fpl_points + team_1_avg,
            manager_count: team_1_managers,
            new_manager_count: team_1_managers - team_1.manager_count,
            gw_points: team_1_avg
          })

        # Draw
        team_1_avg == team_2_avg ->
          update_team(team_1, %{
            draw: team_1.draw + 1,
            points: team_1.points + 1,
            avg_score: team_1.avg_score + team_1_avg,
            fpl_points: team_1.fpl_points + team_1_avg,
            manager_count: team_1_managers,
            new_manager_count: team_1_managers - team_1.manager_count,
            gw_points: team_1_avg
          })

          update_team(team_2, %{
            draw: team_2.draw + 1,
            points: team_2.points + 1,
            avg_score: team_2.avg_score + team_2_avg,
            fpl_points: team_2.fpl_points + team_2_avg,
            manager_count: team_2_managers,
            new_manager_count: team_2_managers - team_2.manager_count,
            gw_points: team_2_avg
          })
      end

      {"#{team_1.name} #{team_1_avg} - #{team_2_avg} #{team_2.name}"}
    end
  end

  @doc """
  Step 3.
  Save fixtures, how teams played against each other.
  """
  def save_gameweek_fixtures(gameweek) do
    average_league_points = calculate_all_average_league_points(gameweek)

    link = "https://fantasy.premierleague.com/api/fixtures/?event=#{gameweek}"

    fixtures = poison_request(link)
    # TODO: Remove below hardcode example
    # derby = [%{"team_h" => 8, "team_h_score" => 88, "team_a" => 12, "team_a_score" => 88}]

    fixtures = fixtures
    # ++ derby
    # team_h, team_a
    # TODO: Save fixtures to the data
    # Run through db fixtures
    for fixture <- fixtures do
      # Match db fixture with the api fixture
      team_h_id = fixture["team_h"]
      team_a_id = fixture["team_a"]

      team_1 = get_team_by_fpl_id(team_h_id)
      team_2 = get_team_by_fpl_id(team_a_id)

      {_, _, team_1_avg, team_1_managers, team_1_hits_avg} =
        Enum.find(average_league_points, fn {_, fpl_league_id, _, _, _} ->
          team_1.fpl_league_id == fpl_league_id
        end)

      {_, _, team_2_avg, team_2_managers, team_2_hits_avg} =
        Enum.find(average_league_points, fn {_, fpl_league_id, _, _, _} ->
          team_2.fpl_league_id == fpl_league_id
        end)

      Fixtures.create_fixture(%{
        team_home_id: team_h_id,
        team_home_score: team_1_avg,
        team_home_name: team_1.name,
        team_away_id: team_a_id,
        team_away_score: team_2_avg,
        team_away_name: team_2.name,
        gameweek: gameweek,
        team_h_manager_count: team_1_managers,
        team_a_manager_count: team_2_managers,
        team_h_id: team_h_id,
        team_a_id: team_a_id,
        team_h_avg_hits: team_1_hits_avg,
        team_a_avg_hits: team_2_hits_avg,
        team_h_score: fixture["team_h_score"],
        team_a_score: fixture["team_a_score"],
        # Manually update every new season
        season: "25/26"
      })

      ##########################################
      # Update table status
      cond do
        team_1_avg > team_2_avg ->
          update_team(team_1, %{
            win: team_1.win + 1,
            points: team_1.points + 3,
            avg_score: team_1.avg_score + team_1_avg,
            fpl_points: team_1.fpl_points + team_1_avg,
            manager_count: team_1_managers,
            new_manager_count: team_1_managers - team_1.manager_count,
            gw_points: team_1_avg
          })

          update_team(team_2, %{
            lose: team_2.lose + 1,
            avg_score: team_2.avg_score + team_2_avg,
            fpl_points: team_2.fpl_points + team_2_avg,
            manager_count: team_2_managers,
            new_manager_count: team_2_managers - team_2.manager_count,
            gw_points: team_2_avg
          })

        team_1_avg < team_2_avg ->
          update_team(team_2, %{
            win: team_2.win + 1,
            points: team_2.points + 3,
            avg_score: team_2.avg_score + team_2_avg,
            fpl_points: team_2.fpl_points + team_2_avg,
            manager_count: team_2_managers,
            new_manager_count: team_2_managers - team_2.manager_count,
            gw_points: team_2_avg
          })

          update_team(team_1, %{
            lose: team_1.lose + 1,
            avg_score: team_1.avg_score + team_1_avg,
            fpl_points: team_1.fpl_points + team_1_avg,
            manager_count: team_1_managers,
            new_manager_count: team_1_managers - team_1.manager_count,
            gw_points: team_1_avg
          })

        # Draw
        team_1_avg == team_2_avg ->
          update_team(team_1, %{
            draw: team_1.draw + 1,
            points: team_1.points + 1,
            avg_score: team_1.avg_score + team_1_avg,
            fpl_points: team_1.fpl_points + team_1_avg,
            manager_count: team_1_managers,
            new_manager_count: team_1_managers - team_1.manager_count,
            gw_points: team_1_avg
          })

          update_team(team_2, %{
            draw: team_2.draw + 1,
            points: team_2.points + 1,
            avg_score: team_2.avg_score + team_2_avg,
            fpl_points: team_2.fpl_points + team_2_avg,
            manager_count: team_2_managers,
            new_manager_count: team_2_managers - team_2.manager_count,
            gw_points: team_2_avg
          })
      end

      {"#{team_1.name} #{team_1_avg} - #{team_2_avg} #{team_2.name}"}
    end
  end

  def manual_fixture_play(gameweek, home_id, away_id) do
    average_league_points = calculate_all_average_league_points(gameweek)

    team_1 = get_team!(home_id)
    team_2 = get_team!(away_id)

    {_, _, team_1_avg, team_1_managers, team_1_hits_avg} =
      Enum.find(average_league_points, fn {_, fpl_league_id, _, _, _} ->
        team_1.fpl_league_id == fpl_league_id
      end)

    {_, _, team_2_avg, team_2_managers, team_2_hits_avg} =
      Enum.find(average_league_points, fn {_, fpl_league_id, _, _, _} ->
        team_2.fpl_league_id == fpl_league_id
      end)

    alias ClashOfClansFpl.Fixtures

    Fixtures.create_fixture(%{
      team_home_id: home_id,
      team_home_score: team_1_avg,
      team_home_name: team_1.name,
      team_away_id: away_id,
      team_away_score: team_2_avg,
      team_away_name: team_2.name,
      gameweek: gameweek,
      team_h_manager_count: team_1_managers,
      team_a_manager_count: team_2_managers,
      team_h_id: home_id,
      team_a_id: away_id,
      team_h_avg_hits: team_1_hits_avg,
      team_a_avg_hits: team_2_hits_avg,
      season: "25/26"
    })

    update_team(team_1, %{gw_points: team_1_avg})
    update_team(team_2, %{gw_points: team_2_avg})

    {"#{team_1.name} #{team_1_avg} - #{team_2_avg} #{team_2.name}"}
  end

  def manual_table_update(gameweek, home_id, away_id) do
    average_league_points = calculate_all_average_league_points(gameweek)

    team_1 = get_team!(home_id)
    team_2 = get_team!(away_id)

    {_, _, team_1_avg, team_1_managers, _} =
      Enum.find(average_league_points, fn {_, fpl_league_id, _, _, _} ->
        team_1.fpl_league_id == fpl_league_id
      end)

    {_, _, team_2_avg, team_2_managers, _} =
      Enum.find(average_league_points, fn {_, fpl_league_id, _, _, _} ->
        team_2.fpl_league_id == fpl_league_id
      end)

    cond do
      team_1_avg > team_2_avg ->
        update_team(team_1, %{
          win: team_1.win + 1,
          points: team_1.points + 3,
          avg_score: team_1.avg_score + team_1_avg,
          fpl_points: team_1.fpl_points + team_1_avg,
          manager_count: team_1_managers,
          new_manager_count: team_1_managers - team_1.manager_count
        })

        update_team(team_2, %{
          lose: team_2.lose + 1,
          avg_score: team_2.avg_score + team_2_avg,
          fpl_points: team_2.fpl_points + team_2_avg,
          manager_count: team_2_managers,
          new_manager_count: team_2_managers - team_2.manager_count
        })

      team_1_avg < team_2_avg ->
        update_team(team_2, %{
          win: team_2.win + 1,
          points: team_2.points + 3,
          avg_score: team_2.avg_score + team_2_avg,
          fpl_points: team_2.fpl_points + team_2_avg,
          manager_count: team_2_managers,
          new_manager_count: team_2_managers - team_2.manager_count
        })

        update_team(team_1, %{
          lose: team_1.lose + 1,
          avg_score: team_1.avg_score + team_1_avg,
          fpl_points: team_1.fpl_points + team_1_avg,
          manager_count: team_1_managers,
          new_manager_count: team_1_managers - team_1.manager_count
        })

      # Draw
      team_1_avg == team_2_avg ->
        update_team(team_1, %{
          draw: team_1.draw + 1,
          points: team_1.points + 1,
          avg_score: team_1.avg_score + team_1_avg,
          fpl_points: team_1.fpl_points + team_1_avg,
          manager_count: team_1_managers,
          new_manager_count: team_1_managers - team_1.manager_count
        })

        update_team(team_2, %{
          draw: team_2.draw + 1,
          points: team_2.points + 1,
          avg_score: team_2.avg_score + team_2_avg,
          fpl_points: team_2.fpl_points + team_2_avg,
          manager_count: team_2_managers,
          new_manager_count: team_2_managers - team_2.manager_count
        })
    end

    {"#{team_1.name} #{team_1_avg} - #{team_2_avg} #{team_2.name}"}
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
    |> length()
  end

  @doc """
  Step 1. Manually check duplicated managers first.
  Run from the console.
  """
  def list_duplicate_managers do
    # Manual season pass
    teams = list_teams("25/26")

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

  def prepare_csv() do
    uuid = Ecto.UUID.generate()
    file_path = Path.join(System.tmp_dir!(), uuid)

    teams = Repo.all(Team) |> Enum.map(fn team -> [team.name, team.points] end)

    csv = teams |> CSV.encode() |> Enum.to_list() |> to_string()
    # csv = teams |> CSV.encode()

    File.write(file_path, csv)
  end

  def update_positions do
    teams = list_teams() |> Enum.with_index(fn team, index -> {team, index + 1} end)

    Enum.each(teams, fn {team, new_position} ->
      update_team(team, %{
        last_position: team.current_position,
        current_position: new_position
      })
    end)
  end

  # def update_manager_count do
  #   teams = list_teams()

  # # Hardcoded gameweek value here
  #   Enum.each(teams, fn team ->
  #     query =
  #       from m in ClashOfClansFpl.Managers.Manager,
  #         where: m.gameweek == 22 and m.league_id == ^team.fpl_league_id,
  #         select: count()

  #     prev_22_count = Repo.one(query)

  #     update_team(team, %{new_manager_count: team.manager_count - prev_22_count})
  #   end)
  # end

  def calculate_median_points(gameweek) do
    teams = list_teams()

    duplicate_manager_ids =
      duplicate_managers_ids()
      # Maybe filter
      |> List.insert_at(-1, "1430773")

    median_league_points =
      Enum.map(teams, fn team ->
        page = 1
        league_id = team.fpl_league_id

        league_link =
          "https://fantasy.premierleague.com/api/leagues-classic/#{league_id}/standings/?page_standings=#{page}"

        body = poison_request(league_link)

        has_next_page? = body["standings"]["has_next"]

        all_managers =
          get_all_managers(league_id, page + 1, body["standings"]["results"], has_next_page?)
          |> Enum.filter(fn manager -> manager["entry"] not in duplicate_manager_ids end)

        managers_current_gw =
          Enum.map(all_managers, fn manager_data ->
            entry = manager_data["entry"]

            history_body =
              poison_request("https://fantasy.premierleague.com/api/entry/#{entry}/history/")

            gameweeks = history_body["current"]
            {manager_data["entry"], Enum.find(gameweeks, fn gw -> gw["event"] == gameweek end)}
          end)

        sorted_managers =
          Enum.map(managers_current_gw, fn {name, current_gameweek} ->
            {name, current_gameweek["points"] - current_gameweek["event_transfers_cost"],
             current_gameweek["rank"], current_gameweek["overall_rank"]}
          end)
          |> Enum.sort_by(fn {_id, pure_points, _GWR, _OR} -> pure_points end, :desc)

        %{
          median_points:
            Median.calculate_median(Enum.map(sorted_managers, fn {_, points, _, _} -> points end)),
          fpl_league_id: team.fpl_league_id
        }
      end)

    link = "https://fantasy.premierleague.com/api/fixtures/?event=#{gameweek}"

    fixtures = poison_request(link)

    # team_h, team_a
    for fixture <- fixtures do
      team_h_id = fixture["team_h"]
      team_a_id = fixture["team_a"]

      team_1 = get_team_by_fpl_id(team_h_id)
      team_2 = get_team_by_fpl_id(team_a_id)

      %{median_points: team_1_median} =
        Enum.find(median_league_points, fn item ->
          team_1.fpl_league_id == item.fpl_league_id
        end)

      %{median_points: team_2_median} =
        Enum.find(median_league_points, fn item ->
          team_2.fpl_league_id == item.fpl_league_id
        end)

      {"#{team_1.name} #{team_1_median} - #{team_2_median} #{team_2.name}"}
    end
  end
end

# Standings.list_duplicate_managers()
# Standings.play_games(gameweek)

defmodule Median do
  def calculate_median(list) do
    sorted_list = Enum.sort(list)
    len = length(sorted_list)

    middle = div(len, 2)

    if rem(len, 2) == 0 do
      # If even number of elements, average the two middle values
      ((Enum.at(sorted_list, middle - 1) + Enum.at(sorted_list, middle)) / 2)
      |> round()
    else
      # If odd number of elements, return the middle value
      Enum.at(sorted_list, middle)
    end
  end
end
