defmodule ClashOfClansFpl.FixturesTest do
  use ClashOfClansFpl.DataCase

  alias ClashOfClansFpl.Fixtures

  describe "fixtures" do
    alias ClashOfClansFpl.Fixtures.Fixture

    import ClashOfClansFpl.FixturesFixtures

    @invalid_attrs %{
      team_home_id: nil,
      team_home_score: nil,
      team_home_name: nil,
      team_away_id: nil,
      team_away_score: nil,
      team_away_name: nil,
      gameweek: nil,
      team_h_manager_count: nil,
      team_a_manager_count: nil
    }

    test "list_fixtures/0 returns all fixtures" do
      fixture = fixture_fixture()
      assert Fixtures.list_fixtures() == [fixture]
    end

    test "get_fixture!/1 returns the fixture with given id" do
      fixture = fixture_fixture()
      assert Fixtures.get_fixture!(fixture.id) == fixture
    end

    test "create_fixture/1 with valid data creates a fixture" do
      valid_attrs = %{
        team_home_id: 42,
        team_home_score: 42,
        team_home_name: "some team_home_name",
        team_away_id: 42,
        team_away_score: 42,
        team_away_name: "some team_away_name",
        gameweek: 42,
        team_h_manager_count: 42,
        team_a_manager_count: 42
      }

      assert {:ok, %Fixture{} = fixture} = Fixtures.create_fixture(valid_attrs)
      assert fixture.team_home_id == 42
      assert fixture.team_home_score == 42
      assert fixture.team_home_name == "some team_home_name"
      assert fixture.team_away_id == 42
      assert fixture.team_away_score == 42
      assert fixture.team_away_name == "some team_away_name"
      assert fixture.gameweek == 42
      assert fixture.team_h_manager_count == 42
      assert fixture.team_a_manager_count == 42
    end

    test "create_fixture/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Fixtures.create_fixture(@invalid_attrs)
    end

    test "update_fixture/2 with valid data updates the fixture" do
      fixture = fixture_fixture()

      update_attrs = %{
        team_home_id: 43,
        team_home_score: 43,
        team_home_name: "some updated team_home_name",
        team_away_id: 43,
        team_away_score: 43,
        team_away_name: "some updated team_away_name",
        gameweek: 43,
        team_h_manager_count: 43,
        team_a_manager_count: 43
      }

      assert {:ok, %Fixture{} = fixture} = Fixtures.update_fixture(fixture, update_attrs)
      assert fixture.team_home_id == 43
      assert fixture.team_home_score == 43
      assert fixture.team_home_name == "some updated team_home_name"
      assert fixture.team_away_id == 43
      assert fixture.team_away_score == 43
      assert fixture.team_away_name == "some updated team_away_name"
      assert fixture.gameweek == 43
      assert fixture.team_h_manager_count == 43
      assert fixture.team_a_manager_count == 43
    end

    test "update_fixture/2 with invalid data returns error changeset" do
      fixture = fixture_fixture()
      assert {:error, %Ecto.Changeset{}} = Fixtures.update_fixture(fixture, @invalid_attrs)
      assert fixture == Fixtures.get_fixture!(fixture.id)
    end

    test "delete_fixture/1 deletes the fixture" do
      fixture = fixture_fixture()
      assert {:ok, %Fixture{}} = Fixtures.delete_fixture(fixture)
      assert_raise Ecto.NoResultsError, fn -> Fixtures.get_fixture!(fixture.id) end
    end

    test "change_fixture/1 returns a fixture changeset" do
      fixture = fixture_fixture()
      assert %Ecto.Changeset{} = Fixtures.change_fixture(fixture)
    end
  end

  describe "get_fixtures_with_hits/1" do
    import ClashOfClansFpl.FixturesFixtures

    test "returns fixtures for specified gameweek with hits formatted" do
      fixture_fixture(%{
        gameweek: 5,
        team_home_name: "Arsenal",
        team_away_name: "Chelsea",
        team_h_avg_hits: 2.5,
        team_a_avg_hits: 1.25
      })

      result = Fixtures.get_fixtures_with_hits(5)

      assert length(result) == 1
      assert {"Arsenal 2.5 — 1.25 Chelsea"} in result
    end

    test "returns empty list when no fixtures for gameweek" do
      fixture_fixture(%{gameweek: 5})

      result = Fixtures.get_fixtures_with_hits(10)
      assert result == []
    end

    test "returns multiple fixtures for same gameweek" do
      fixture_fixture(%{
        gameweek: 3,
        team_home_name: "Arsenal",
        team_away_name: "Chelsea",
        team_h_avg_hits: 1.0,
        team_a_avg_hits: 2.0,
        team_home_id: 1,
        team_away_id: 2
      })

      fixture_fixture(%{
        gameweek: 3,
        team_home_name: "Liverpool",
        team_away_name: "Man United",
        team_h_avg_hits: 0.5,
        team_a_avg_hits: 3.333,
        team_home_id: 3,
        team_away_id: 4
      })

      result = Fixtures.get_fixtures_with_hits(3)

      assert length(result) == 2
      assert {"Arsenal 1.0 — 2.0 Chelsea"} in result
      assert {"Liverpool 0.5 — 3.333 Man United"} in result
    end

    test "rounds hits to 3 decimal places" do
      fixture_fixture(%{
        gameweek: 1,
        team_home_name: "Team A",
        team_away_name: "Team B",
        team_h_avg_hits: 1.123456,
        team_a_avg_hits: 2.999999
      })

      result = Fixtures.get_fixtures_with_hits(1)

      assert {"Team A 1.123 — 3.0 Team B"} in result
    end

    test "handles zero hits" do
      fixture_fixture(%{
        gameweek: 1,
        team_home_name: "Team A",
        team_away_name: "Team B",
        team_h_avg_hits: 0.0,
        team_a_avg_hits: 0.0
      })

      result = Fixtures.get_fixtures_with_hits(1)

      assert {"Team A 0.0 — 0.0 Team B"} in result
    end

    test "only returns fixtures from specified gameweek" do
      fixture_fixture(%{
        gameweek: 1,
        team_home_name: "GW1 Home",
        team_away_name: "GW1 Away",
        team_h_avg_hits: 1.0,
        team_a_avg_hits: 1.0,
        team_home_id: 1,
        team_away_id: 2
      })

      fixture_fixture(%{
        gameweek: 2,
        team_home_name: "GW2 Home",
        team_away_name: "GW2 Away",
        team_h_avg_hits: 2.0,
        team_a_avg_hits: 2.0,
        team_home_id: 3,
        team_away_id: 4
      })

      result_gw1 = Fixtures.get_fixtures_with_hits(1)
      result_gw2 = Fixtures.get_fixtures_with_hits(2)

      assert length(result_gw1) == 1
      assert {"GW1 Home 1.0 — 1.0 GW1 Away"} in result_gw1

      assert length(result_gw2) == 1
      assert {"GW2 Home 2.0 — 2.0 GW2 Away"} in result_gw2
    end
  end
end
