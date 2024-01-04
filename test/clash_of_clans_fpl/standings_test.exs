defmodule ClashOfClansFpl.StandingsTest do
  use ClashOfClansFpl.DataCase

  alias ClashOfClansFpl.Standings

  describe "teams" do
    alias ClashOfClansFpl.Standings.Team

    import ClashOfClansFpl.StandingsFixtures

    @invalid_attrs %{name: nil, points: nil, manager_count: nil, win: nil, draw: nil, lose: nil, avg_score: nil, fpl_points: nil, fpl_id: nil, fpl_league_id: nil}

    test "list_teams/0 returns all teams" do
      team = team_fixture()
      assert Standings.list_teams() == [team]
    end

    test "get_team!/1 returns the team with given id" do
      team = team_fixture()
      assert Standings.get_team!(team.id) == team
    end

    test "create_team/1 with valid data creates a team" do
      valid_attrs = %{name: "some name", points: 42, manager_count: 42, win: 42, draw: 42, lose: 42, avg_score: 120.5, fpl_points: 42, fpl_id: 42, fpl_league_id: 42}

      assert {:ok, %Team{} = team} = Standings.create_team(valid_attrs)
      assert team.name == "some name"
      assert team.points == 42
      assert team.manager_count == 42
      assert team.win == 42
      assert team.draw == 42
      assert team.lose == 42
      assert team.avg_score == 120.5
      assert team.fpl_points == 42
      assert team.fpl_id == 42
      assert team.fpl_league_id == 42
    end

    test "create_team/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Standings.create_team(@invalid_attrs)
    end

    test "update_team/2 with valid data updates the team" do
      team = team_fixture()
      update_attrs = %{name: "some updated name", points: 43, manager_count: 43, win: 43, draw: 43, lose: 43, avg_score: 456.7, fpl_points: 43, fpl_id: 43, fpl_league_id: 43}

      assert {:ok, %Team{} = team} = Standings.update_team(team, update_attrs)
      assert team.name == "some updated name"
      assert team.points == 43
      assert team.manager_count == 43
      assert team.win == 43
      assert team.draw == 43
      assert team.lose == 43
      assert team.avg_score == 456.7
      assert team.fpl_points == 43
      assert team.fpl_id == 43
      assert team.fpl_league_id == 43
    end

    test "update_team/2 with invalid data returns error changeset" do
      team = team_fixture()
      assert {:error, %Ecto.Changeset{}} = Standings.update_team(team, @invalid_attrs)
      assert team == Standings.get_team!(team.id)
    end

    test "delete_team/1 deletes the team" do
      team = team_fixture()
      assert {:ok, %Team{}} = Standings.delete_team(team)
      assert_raise Ecto.NoResultsError, fn -> Standings.get_team!(team.id) end
    end

    test "change_team/1 returns a team changeset" do
      team = team_fixture()
      assert %Ecto.Changeset{} = Standings.change_team(team)
    end
  end
end
