defmodule ClashOfClansFpl.FixturesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ClashOfClansFpl.Fixtures` context.
  """

  @doc """
  Generate a fixture.
  """
  def fixture_fixture(attrs \\ %{}) do
    {:ok, fixture} =
      attrs
      |> Enum.into(%{
        gameweek: 42,
        team_a_manager_count: 42,
        team_away_id: 42,
        team_away_name: "some team_away_name",
        team_away_score: 42,
        team_h_manager_count: 42,
        team_home_id: 42,
        team_home_name: "some team_home_name",
        team_home_score: 42,
        team_h_avg_hits: 0.0,
        team_a_avg_hits: 0.0
      })
      |> ClashOfClansFpl.Fixtures.create_fixture()

    fixture
  end
end
