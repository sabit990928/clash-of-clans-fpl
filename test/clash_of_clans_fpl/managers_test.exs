defmodule ClashOfClansFpl.ManagersTest do
  use ClashOfClansFpl.DataCase

  alias ClashOfClansFpl.Managers

  describe "managers" do
    alias ClashOfClansFpl.Managers.Manager

    import ClashOfClansFpl.ManagersFixtures

    @invalid_attrs %{
      name: nil,
      gameweek: nil,
      team_name: nil,
      league_id: nil,
      team_id: nil,
      league_name: nil
    }

    test "list_managers/0 returns all managers" do
      manager = manager_fixture()
      assert Managers.list_managers() == [manager]
    end

    test "get_manager!/1 returns the manager with given id" do
      manager = manager_fixture()
      assert Managers.get_manager!(manager.id) == manager
    end

    test "create_manager/1 with valid data creates a manager" do
      valid_attrs = %{
        name: "some name",
        gameweek: 42,
        team_name: "some team_name",
        league_id: 42,
        team_id: 42,
        league_name: "some league_name"
      }

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

      update_attrs = %{
        name: "some updated name",
        gameweek: 43,
        team_name: "some updated team_name",
        league_id: 43,
        team_id: 43,
        league_name: "some updated league_name"
      }

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

  describe "get_mvp_managers/1" do
    import ClashOfClansFpl.ManagersFixtures

    test "returns MVP managers for specified gameweek" do
      manager_fixture(%{
        name: "MVP Manager",
        gameweek: 5,
        league_name: "Arsenal FC",
        mvp?: true,
        league_id: 1,
        team_id: 1
      })

      result = Managers.get_mvp_managers(5)

      assert length(result) == 1
      assert {"MVP Manager", "Arsenal FC"} in result
    end

    test "returns empty list when no MVP managers for gameweek" do
      manager_fixture(%{gameweek: 5, mvp?: false})

      result = Managers.get_mvp_managers(5)
      assert result == []
    end

    test "only returns managers with mvp? == true" do
      manager_fixture(%{
        name: "MVP",
        gameweek: 3,
        league_name: "League A",
        mvp?: true,
        league_id: 1,
        team_id: 1
      })

      manager_fixture(%{
        name: "Non-MVP",
        gameweek: 3,
        league_name: "League B",
        mvp?: false,
        league_id: 2,
        team_id: 2
      })

      result = Managers.get_mvp_managers(3)

      assert length(result) == 1
      assert {"MVP", "League A"} in result
      refute {"Non-MVP", "League B"} in result
    end

    test "returns multiple MVP managers for same gameweek" do
      manager_fixture(%{
        name: "Manager A",
        gameweek: 1,
        league_name: "Zebra League",
        mvp?: true,
        league_id: 1,
        team_id: 1
      })

      manager_fixture(%{
        name: "Manager B",
        gameweek: 1,
        league_name: "Alpha League",
        mvp?: true,
        league_id: 2,
        team_id: 2
      })

      result = Managers.get_mvp_managers(1)

      assert length(result) == 2
      assert {"Manager A", "Zebra League"} in result
      assert {"Manager B", "Alpha League"} in result
    end

    test "orders results by league_name" do
      manager_fixture(%{
        name: "Manager Z",
        gameweek: 1,
        league_name: "Zebra League",
        mvp?: true,
        league_id: 1,
        team_id: 1
      })

      manager_fixture(%{
        name: "Manager A",
        gameweek: 1,
        league_name: "Alpha League",
        mvp?: true,
        league_id: 2,
        team_id: 2
      })

      manager_fixture(%{
        name: "Manager M",
        gameweek: 1,
        league_name: "Middle League",
        mvp?: true,
        league_id: 3,
        team_id: 3
      })

      result = Managers.get_mvp_managers(1)

      assert result == [
               {"Manager A", "Alpha League"},
               {"Manager M", "Middle League"},
               {"Manager Z", "Zebra League"}
             ]
    end

    test "only returns managers from specified gameweek" do
      manager_fixture(%{
        name: "GW1 MVP",
        gameweek: 1,
        league_name: "League",
        mvp?: true,
        league_id: 1,
        team_id: 1
      })

      manager_fixture(%{
        name: "GW2 MVP",
        gameweek: 2,
        league_name: "League",
        mvp?: true,
        league_id: 2,
        team_id: 2
      })

      result_gw1 = Managers.get_mvp_managers(1)
      result_gw2 = Managers.get_mvp_managers(2)

      assert length(result_gw1) == 1
      assert {"GW1 MVP", "League"} in result_gw1

      assert length(result_gw2) == 1
      assert {"GW2 MVP", "League"} in result_gw2
    end

    test "returns empty list for non-existent gameweek" do
      manager_fixture(%{gameweek: 1, mvp?: true})

      result = Managers.get_mvp_managers(99)
      assert result == []
    end
  end
end
