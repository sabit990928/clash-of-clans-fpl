defmodule ClashOfClansFpl.StandingsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ClashOfClansFpl.Standings` context.
  """

  @doc """
  Generate a team.
  """
  def team_fixture(attrs \\ %{}) do
    {:ok, team} =
      attrs
      |> Enum.into(%{
        avg_score: 120.5,
        draw: 42,
        fpl_id: 42,
        fpl_league_id: 42,
        fpl_points: 42,
        lose: 42,
        manager_count: 42,
        name: "some name",
        points: 42,
        win: 42
      })
      |> ClashOfClansFpl.Standings.create_team()

    team
  end
end
