defmodule ClashOfClansFpl.ManagersTest do
  use ClashOfClansFpl.DataCase

  alias ClashOfClansFpl.Managers

  describe "managers" do
    alias ClashOfClansFpl.Managers.Manager

    import ClashOfClansFpl.ManagersFixtures

    @invalid_attrs %{name: nil, gameweek: nil, team_name: nil, league_id: nil, team_id: nil, league_name: nil}

    test "list_managers/0 returns all managers" do
      manager = manager_fixture()
      assert Managers.list_managers() == [manager]
    end

    test "get_manager!/1 returns the manager with given id" do
      manager = manager_fixture()
      assert Managers.get_manager!(manager.id) == manager
    end

    test "create_manager/1 with valid data creates a manager" do
      valid_attrs = %{name: "some name", gameweek: 42, team_name: "some team_name", league_id: 42, team_id: 42, league_name: "some league_name"}

      assert {:ok, %Manager{} = manager} = Managers.create_manager(valid_attrs)
      assert manager.name == "some name"
      assert manager.gameweek == 42
      assert manager.team_name == "some team_name"
      assert manager.league_id == 42
      assert manager.team_id == 42
      assert manager.league_name == "some league_name"
    end

    test "create_manager/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Managers.create_manager(@invalid_attrs)
    end

    test "update_manager/2 with valid data updates the manager" do
      manager = manager_fixture()
      update_attrs = %{name: "some updated name", gameweek: 43, team_name: "some updated team_name", league_id: 43, team_id: 43, league_name: "some updated league_name"}

      assert {:ok, %Manager{} = manager} = Managers.update_manager(manager, update_attrs)
      assert manager.name == "some updated name"
      assert manager.gameweek == 43
      assert manager.team_name == "some updated team_name"
      assert manager.league_id == 43
      assert manager.team_id == 43
      assert manager.league_name == "some updated league_name"
    end

    test "update_manager/2 with invalid data returns error changeset" do
      manager = manager_fixture()
      assert {:error, %Ecto.Changeset{}} = Managers.update_manager(manager, @invalid_attrs)
      assert manager == Managers.get_manager!(manager.id)
    end

    test "delete_manager/1 deletes the manager" do
      manager = manager_fixture()
      assert {:ok, %Manager{}} = Managers.delete_manager(manager)
      assert_raise Ecto.NoResultsError, fn -> Managers.get_manager!(manager.id) end
    end

    test "change_manager/1 returns a manager changeset" do
      manager = manager_fixture()
      assert %Ecto.Changeset{} = Managers.change_manager(manager)
    end
  end
end
