defmodule ClashOfClansFpl.Useless do
  import Ecto.Query, warn: false
  alias ClashOfClansFpl.Repo

  alias ClashOfClansFpl.Managers.Manager

  def get_and_update_mvp_managers(gameweek) do
    managers =
      from(m in Manager,
        where: m.gameweek == ^gameweek and m.mvp? == true,
        # select: {m.name, m.league_name},
        order_by: m.league_name
      )
      |> Repo.all()

    alias ClashOfClansFpl.Standings

    Enum.map(managers, fn manager ->
      entry = manager.team_id

      history_body =
        Standings.poison_request("https://fantasy.premierleague.com/api/entry/#{entry}/history/")

      gameweeks = history_body["current"]
      current_gameweek = Enum.find(gameweeks, fn gw -> gw["event"] == gameweek end)

      # update_manager(manager, %{
      #   gw_points: current_gameweek["points"] - current_gameweek["event_transfers_cost"],
      #   gw_rank: current_gameweek["rank"]
      # })
    end)
  end

  # Use new_entries instead of standings if you was late on league creation before the first gameweek

  # TODO: Hardcoded
  def list_new_entries_duplicate_managers do
    # Manual season pass
    teams = list_teams("25/26")

    Enum.map(teams, fn team ->
      page = 1
      league_id = team.fpl_league_id

      league_link =
        "https://fantasy.premierleague.com/api/leagues-classic/#{league_id}/standings/?page_standings=#{page}"

      body = poison_request(league_link)

      has_next_page? = body["new_entries"]["has_next"]

      get_all_managers(league_id, page + 1, body["new_entries"]["results"], has_next_page?)
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
end
