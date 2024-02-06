defmodule ClashOfClansFpl.FixturesTest do
  use ClashOfClansFpl.DataCase

  alias ClashOfClansFpl.Fixtures

  describe "fixtures" do
    alias ClashOfClansFpl.Fixtures.Fixture

    import ClashOfClansFpl.FixturesFixtures

    @invalid_attrs %{team_home_id: nil, team_home_score: nil, team_home_name: nil, team_away_id: nil, team_away_score: nil, team_away_name: nil, gameweek: nil, team_h_manager_count: nil, team_a_manager_count: nil}

    test "list_fixtures/0 returns all fixtures" do
      fixture = fixture_fixture()
      assert Fixtures.list_fixtures() == [fixture]
    end

    test "get_fixture!/1 returns the fixture with given id" do
      fixture = fixture_fixture()
      assert Fixtures.get_fixture!(fixture.id) == fixture
    end

    test "create_fixture/1 with valid data creates a fixture" do
      valid_attrs = %{team_home_id: 42, team_home_score: 42, team_home_name: "some team_home_name", team_away_id: 42, team_away_score: 42, team_away_name: "some team_away_name", gameweek: 42, team_h_manager_count: 42, team_a_manager_count: 42}

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
      update_attrs = %{team_home_id: 43, team_home_score: 43, team_home_name: "some updated team_home_name", team_away_id: 43, team_away_score: 43, team_away_name: "some updated team_away_name", gameweek: 43, team_h_manager_count: 43, team_a_manager_count: 43}

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
end
