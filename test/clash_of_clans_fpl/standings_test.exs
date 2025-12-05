defmodule ClashOfClansFpl.StandingsTest do
  use ClashOfClansFpl.DataCase

  alias ClashOfClansFpl.Standings

  describe "teams" do
    alias ClashOfClansFpl.Standings.Team

    import ClashOfClansFpl.StandingsFixtures

    @invalid_attrs %{
      name: nil,
      points: nil,
      manager_count: nil,
      win: nil,
      draw: nil,
      lose: nil,
      avg_score: nil,
      fpl_points: nil,
      fpl_id: nil,
      fpl_league_id: nil
    }

    test "list_teams/0 returns all teams" do
      team = team_fixture()
      assert Standings.list_teams() == [team]
    end

    test "get_team!/1 returns the team with given id" do
      team = team_fixture()
      assert Standings.get_team!(team.id) == team
    end

    test "create_team/1 with valid data creates a team" do
      valid_attrs = %{
        name: "some name",
        points: 42,
        manager_count: 42,
        win: 42,
        draw: 42,
        lose: 42,
        avg_score: 120.5,
        fpl_points: 42,
        fpl_id: 42,
        fpl_league_id: 42
      }

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

      update_attrs = %{
        name: "some updated name",
        points: 43,
        manager_count: 43,
        win: 43,
        draw: 43,
        lose: 43,
        avg_score: 456.7,
        fpl_points: 43,
        fpl_id: 43,
        fpl_league_id: 43
      }

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

  describe "list_teams/1 with season filtering" do
    import ClashOfClansFpl.StandingsFixtures

    test "returns teams for the specified season" do
      team_25_26 = team_fixture(%{name: "Team A", season: "25/26", fpl_id: 1, fpl_league_id: 1})

      team_24_25 =
        team_fixture(%{name: "Team B", season: "24/25", fpl_id: 2, fpl_league_id: 2})

      assert Standings.list_teams("25/26") == [team_25_26]
      assert Standings.list_teams("24/25") == [team_24_25]
    end

    test "returns empty list when no teams exist for season" do
      team_fixture(%{season: "25/26", fpl_id: 1, fpl_league_id: 1})
      assert Standings.list_teams("23/24") == []
    end

    test "orders teams by points descending, then fpl_points descending, then manager_count ascending" do
      team_a =
        team_fixture(%{
          name: "Low Points",
          points: 10,
          fpl_points: 100,
          manager_count: 50,
          fpl_id: 1,
          fpl_league_id: 1
        })

      team_b =
        team_fixture(%{
          name: "High Points",
          points: 30,
          fpl_points: 200,
          manager_count: 40,
          fpl_id: 2,
          fpl_league_id: 2
        })

      team_c =
        team_fixture(%{
          name: "Mid Points",
          points: 20,
          fpl_points: 150,
          manager_count: 30,
          fpl_id: 3,
          fpl_league_id: 3
        })

      result = Standings.list_teams()
      assert Enum.map(result, & &1.id) == [team_b.id, team_c.id, team_a.id]
    end

    test "when points are equal, orders by fpl_points descending" do
      team_a =
        team_fixture(%{
          name: "Low FPL",
          points: 20,
          fpl_points: 100,
          manager_count: 50,
          fpl_id: 1,
          fpl_league_id: 1
        })

      team_b =
        team_fixture(%{
          name: "High FPL",
          points: 20,
          fpl_points: 200,
          manager_count: 40,
          fpl_id: 2,
          fpl_league_id: 2
        })

      result = Standings.list_teams()
      assert Enum.map(result, & &1.id) == [team_b.id, team_a.id]
    end

    test "when points and fpl_points are equal, orders by manager_count ascending" do
      team_a =
        team_fixture(%{
          name: "More Managers",
          points: 20,
          fpl_points: 100,
          manager_count: 50,
          fpl_id: 1,
          fpl_league_id: 1
        })

      team_b =
        team_fixture(%{
          name: "Fewer Managers",
          points: 20,
          fpl_points: 100,
          manager_count: 30,
          fpl_id: 2,
          fpl_league_id: 2
        })

      result = Standings.list_teams()
      assert Enum.map(result, & &1.id) == [team_b.id, team_a.id]
    end
  end

  describe "get_team_by_fpl_id/2" do
    import ClashOfClansFpl.StandingsFixtures

    test "returns team with matching fpl_id and season" do
      team = team_fixture(%{fpl_id: 123, fpl_league_id: 456, season: "25/26"})
      assert Standings.get_team_by_fpl_id(123, "25/26") == team
    end

    test "uses default season when not specified" do
      team = team_fixture(%{fpl_id: 123, fpl_league_id: 456, season: "25/26"})
      assert Standings.get_team_by_fpl_id(123) == team
    end

    test "raises when team not found for fpl_id" do
      assert_raise Ecto.NoResultsError, fn ->
        Standings.get_team_by_fpl_id(999)
      end
    end

    test "raises when team exists but for different season" do
      team_fixture(%{fpl_id: 123, fpl_league_id: 456, season: "24/25"})

      assert_raise Ecto.NoResultsError, fn ->
        Standings.get_team_by_fpl_id(123, "25/26")
      end
    end

    test "returns correct team when same fpl_id exists in different seasons" do
      team_24_25 = team_fixture(%{fpl_id: 123, fpl_league_id: 456, season: "24/25"})
      team_25_26 = team_fixture(%{fpl_id: 123, fpl_league_id: 457, season: "25/26"})

      assert Standings.get_team_by_fpl_id(123, "24/25") == team_24_25
      assert Standings.get_team_by_fpl_id(123, "25/26") == team_25_26
    end
  end

  describe "update_positions/0" do
    import ClashOfClansFpl.StandingsFixtures

    test "updates current and last positions for all teams based on standings order" do
      # Create teams with different points - they'll be ordered by points desc
      _team_a =
        team_fixture(%{
          name: "Third",
          points: 10,
          fpl_points: 100,
          current_position: nil,
          last_position: nil,
          fpl_id: 1,
          fpl_league_id: 1
        })

      _team_b =
        team_fixture(%{
          name: "First",
          points: 30,
          fpl_points: 300,
          current_position: nil,
          last_position: nil,
          fpl_id: 2,
          fpl_league_id: 2
        })

      _team_c =
        team_fixture(%{
          name: "Second",
          points: 20,
          fpl_points: 200,
          current_position: nil,
          last_position: nil,
          fpl_id: 3,
          fpl_league_id: 3
        })

      Standings.update_positions()

      # Reload teams and check positions
      teams = Standings.list_teams()

      first_place = Enum.find(teams, &(&1.name == "First"))
      second_place = Enum.find(teams, &(&1.name == "Second"))
      third_place = Enum.find(teams, &(&1.name == "Third"))

      assert first_place.current_position == 1
      assert second_place.current_position == 2
      assert third_place.current_position == 3
    end

    test "preserves previous position as last_position" do
      team =
        team_fixture(%{
          name: "Team",
          points: 10,
          current_position: 5,
          last_position: nil,
          fpl_id: 1,
          fpl_league_id: 1
        })

      Standings.update_positions()

      updated_team = Standings.get_team!(team.id)
      assert updated_team.last_position == 5
      assert updated_team.current_position == 1
    end

    test "handles single team correctly" do
      team =
        team_fixture(%{
          name: "Only Team",
          points: 10,
          current_position: nil,
          fpl_id: 1,
          fpl_league_id: 1
        })

      Standings.update_positions()

      updated_team = Standings.get_team!(team.id)
      assert updated_team.current_position == 1
    end

    test "handles empty teams list" do
      # Should not raise error
      assert Standings.update_positions() == :ok
    end
  end

  describe "reset_teams_table/0" do
    import ClashOfClansFpl.StandingsFixtures

    test "resets all team statistics to zero" do
      team =
        team_fixture(%{
          name: "Team",
          points: 50,
          win: 15,
          draw: 5,
          lose: 3,
          fpl_points: 1500,
          manager_count: 100,
          avg_score: 75.5,
          fpl_id: 1,
          fpl_league_id: 1
        })

      Standings.reset_teams_table()

      updated_team = Standings.get_team!(team.id)
      assert updated_team.points == 0
      assert updated_team.win == 0
      assert updated_team.draw == 0
      assert updated_team.lose == 0
      assert updated_team.fpl_points == 0
      assert updated_team.manager_count == 0
      assert updated_team.avg_score == 0
    end

    test "resets multiple teams" do
      team_a =
        team_fixture(%{
          name: "Team A",
          points: 30,
          win: 10,
          fpl_id: 1,
          fpl_league_id: 1
        })

      team_b =
        team_fixture(%{
          name: "Team B",
          points: 20,
          win: 5,
          fpl_id: 2,
          fpl_league_id: 2
        })

      Standings.reset_teams_table()

      updated_a = Standings.get_team!(team_a.id)
      updated_b = Standings.get_team!(team_b.id)

      assert updated_a.points == 0
      assert updated_a.win == 0
      assert updated_b.points == 0
      assert updated_b.win == 0
    end

    test "preserves non-stat fields" do
      team =
        team_fixture(%{
          name: "Preserved Name",
          points: 50,
          fpl_id: 123,
          fpl_league_id: 456,
          season: "25/26"
        })

      Standings.reset_teams_table()

      updated_team = Standings.get_team!(team.id)
      assert updated_team.name == "Preserved Name"
      assert updated_team.fpl_id == 123
      assert updated_team.fpl_league_id == 456
      assert updated_team.season == "25/26"
    end
  end
end
