defmodule ClashOfClansFpl.SecondHalf do
  import Ecto.Query

  alias ClashOfClansFpl.Managers
  alias ClashOfClansFpl.Managers.Manager
  alias ClashOfClansFpl.Repo
  alias ClashOfClansFpl.Fixtures

  alias ClashOfClansFpl.Standings

  # List managers for the provided gameweek
  def final_managers_list(gw) do
    query = from m in Manager, where: m.gameweek == ^gw and m.season == "25/26"

    Repo.all(query)
  end

  def copy_gw_managers_from_previous(gw) do
    previous_gw_managers = final_managers_list(gw - 1)

    Enum.each(previous_gw_managers, fn manager ->
      Managers.create_manager(%{
        name: manager.name,
        gameweek: gw,
        team_name: manager.team_name,
        league_id: manager.league_id,
        team_id: manager.team_id,
        league_name: manager.league_name,
        season: manager.season
      })
    end)
  end

  def local_save_gameweek_fixtures(gameweek) do
    teams = Standings.list_teams("25/26")

    managers = final_managers_list(gameweek)

    gameweek_average = Standings.get_average_gameweek_point(gameweek)

    teams_with_average =
      for team <- teams do
        league_managers = Enum.filter(managers, &(&1.league_id == team.fpl_league_id))

        managers_current_gw =
          Enum.map(league_managers, fn manager ->
            team_id = manager.team_id

            history_body =
              Standings.poison_request(
                "https://fantasy.premierleague.com/api/entry/#{team_id}/history/"
              )

            gameweeks = history_body["current"]
            {team_id, Enum.find(gameweeks, fn gw -> gw["event"] == gameweek end)}
          end)

        sorted_managers =
          Enum.map(managers_current_gw, fn {team_id, current_gameweek} ->
            {team_id, current_gameweek["points"] - current_gameweek["event_transfers_cost"],
             current_gameweek["rank"], current_gameweek["overall_rank"]}
          end)
          |> Enum.sort_by(fn {_id, pure_points, _GWR, _OR} -> pure_points end, :desc)

        # Get the highest point in the league
        {_id, max_points, _GWR, _OR} = hd(sorted_managers)

        # Get all managers with the highest points
        all_mvp_managers =
          Enum.filter(sorted_managers, fn {_id, points, _GWR, _OR} -> points == max_points end)

        # maybe refactor that logic
        # Mark as mvp
        Enum.each(all_mvp_managers, fn {fpl_id, points, gameweek_rank, overall_rank} ->
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
          if length(league_managers) > 0 do
            (sum / length(league_managers))
            |> round()
          else
            gameweek_average
          end

        hits_average =
          if length(league_managers) > 0 && hits_sum !== 0 do
            hits_sum / length(league_managers)
          else
            0
          end

        {team.name, team.fpl_league_id, average, length(league_managers), hits_average}
      end

    link = "https://fantasy.premierleague.com/api/fixtures/?event=#{gameweek}"

    # TODO: remove after double gameweek
    # |> Enum.slice(0..9)
    # Convenient for the blank fixtures
    fixtures =
      Standings.poison_request(link)

    #  ++
    #   [
    #     # Man city vs Aston villa
    #     %{
    #       "team_h" => 13,
    #       "team_h_score" => 2,
    #       "team_a" => 2,
    #       "team_a_score" => 1
    #     },
    #     # Arsenal vs Crystal Palace
    #     %{
    #       "team_h" => 1,
    #       "team_h_score" => 2,
    #       "team_a" => 7,
    #       "team_a_score" => 2
    #     }
    #   ]

    # TODO: Save fixtures to the data
    # Run through db fixtures
    for fixture <- fixtures do
      # Match db fixture with the api fixture
      team_h_id = fixture["team_h"]
      team_a_id = fixture["team_a"]

      team_1 = Standings.get_team_by_fpl_id(team_h_id)
      team_2 = Standings.get_team_by_fpl_id(team_a_id)

      {_, _, team_1_avg, team_1_managers, team_1_hits_avg} =
        Enum.find(teams_with_average, fn {_, fpl_league_id, _, _, _} ->
          team_1.fpl_league_id == fpl_league_id
        end)

      {_, _, team_2_avg, team_2_managers, team_2_hits_avg} =
        Enum.find(teams_with_average, fn {_, fpl_league_id, _, _, _} ->
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
          Standings.update_team(team_1, %{
            win: team_1.win + 1,
            points: team_1.points + 3,
            avg_score: team_1.avg_score + team_1_avg,
            fpl_points: team_1.fpl_points + team_1_avg,
            manager_count: team_1_managers,
            new_manager_count: team_1_managers - team_1.manager_count,
            gw_points: team_1_avg
          })

          Standings.update_team(team_2, %{
            lose: team_2.lose + 1,
            avg_score: team_2.avg_score + team_2_avg,
            fpl_points: team_2.fpl_points + team_2_avg,
            manager_count: team_2_managers,
            new_manager_count: team_2_managers - team_2.manager_count,
            gw_points: team_2_avg
          })

        team_1_avg < team_2_avg ->
          Standings.update_team(team_2, %{
            win: team_2.win + 1,
            points: team_2.points + 3,
            avg_score: team_2.avg_score + team_2_avg,
            fpl_points: team_2.fpl_points + team_2_avg,
            manager_count: team_2_managers,
            new_manager_count: team_2_managers - team_2.manager_count,
            gw_points: team_2_avg
          })

          Standings.update_team(team_1, %{
            lose: team_1.lose + 1,
            avg_score: team_1.avg_score + team_1_avg,
            fpl_points: team_1.fpl_points + team_1_avg,
            manager_count: team_1_managers,
            new_manager_count: team_1_managers - team_1.manager_count,
            gw_points: team_1_avg
          })

        # Draw
        team_1_avg == team_2_avg ->
          Standings.update_team(team_1, %{
            draw: team_1.draw + 1,
            points: team_1.points + 1,
            avg_score: team_1.avg_score + team_1_avg,
            fpl_points: team_1.fpl_points + team_1_avg,
            manager_count: team_1_managers,
            new_manager_count: team_1_managers - team_1.manager_count,
            gw_points: team_1_avg
          })

          Standings.update_team(team_2, %{
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

  # history_body =
  #   poison_request("https://fantasy.premierleague.com/api/entry/#{entry}/history/")

  # Calculate points for the gameweek depend on that players

  def test_fixtures do
    link = "https://fantasy.premierleague.com/api/fixtures/?event=29"
    fixtures = Standings.poison_request(link)
    # |> Enum.slice(0..9)

    [
      # Aston Villa vs Liverpool
      %{
        "team_a" => 12,
        "team_a_score" => 2,
        "team_h" => 2,
        "team_h_score" => 2
      },
      # Newcastle vs Crystal Palace
      %{
        "team_a" => 7,
        "team_a_score" => nil,
        "team_h" => 15,
        "team_h_score" => nil
      }
    ]
  end
end
