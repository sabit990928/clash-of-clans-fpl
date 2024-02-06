defmodule ClashOfClansFpl.ManagersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ClashOfClansFpl.Managers` context.
  """

  @doc """
  Generate a manager.
  """
  def manager_fixture(attrs \\ %{}) do
    {:ok, manager} =
      attrs
      |> Enum.into(%{
        gameweek: 42,
        league_id: 42,
        league_name: "some league_name",
        name: "some name",
        team_id: 42,
        team_name: "some team_name"
      })
      |> ClashOfClansFpl.Managers.create_manager()

    manager
  end
end
