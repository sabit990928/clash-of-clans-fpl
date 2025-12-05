defmodule ClashOfClansFpl.PipelineDetector do
  @moduledoc """
  Determines which processing pipeline to use based on gameweek.

  Regular pipeline (GW 1-19): Uses live FPL API to fetch manager data
  SecondHalf pipeline (GW 20-38): Uses frozen manager list from previous gameweek

  The SecondHalf pipeline is used during the second half of the season
  (gameweeks 20-38) when we want to freeze the manager lists to prevent
  league-hopping mid-season.
  """

  import Ecto.Query
  alias ClashOfClansFpl.Repo
  alias ClashOfClansFpl.Managers.Manager

  # First half: GW 1-19 (regular pipeline)
  # Second half: GW 20-38 (second half pipeline)
  @first_half_gameweeks 1..19
  @second_half_gameweeks 20..38

  @doc """
  Returns :regular or :second_half based on the gameweek.

  Detection logic:
  1. GW 1-19: Regular pipeline (fetch fresh managers from API)
  2. GW 20-38: SecondHalf pipeline (copy managers from previous GW)
  """
  @spec detect_pipeline(integer(), String.t()) :: :regular | :second_half
  def detect_pipeline(gameweek, _season \\ "25/26") do
    cond do
      gameweek in @first_half_gameweeks -> :regular
      gameweek in @second_half_gameweeks -> :second_half
      # Fallback for unexpected gameweeks (e.g., extra GWs due to postponements)
      true -> :regular
    end
  end

  @doc """
  Check if a gameweek is in the first half (1-19).
  """
  @spec first_half?(integer()) :: boolean()
  def first_half?(gameweek), do: gameweek in @first_half_gameweeks

  @doc """
  Check if a gameweek is in the second half (20-38).
  """
  @spec second_half?(integer()) :: boolean()
  def second_half?(gameweek), do: gameweek in @second_half_gameweeks

  @doc """
  Get a human-readable description of which pipeline will be used.
  Useful for logging and debugging.
  """
  @spec describe_pipeline(integer(), String.t()) :: String.t()
  def describe_pipeline(gameweek, _season \\ "25/26") do
    pipeline = detect_pipeline(gameweek)

    reason =
      cond do
        gameweek in @first_half_gameweeks -> "first half (GW 1-19)"
        gameweek in @second_half_gameweeks -> "second half (GW 20-38)"
        true -> "fallback"
      end

    "GW#{gameweek}: #{pipeline} pipeline (#{reason})"
  end

  @doc """
  Check if the previous gameweek has managers in the database.
  Used to verify data is available for SecondHalf pipeline.
  """
  @spec has_previous_gameweek_managers?(integer(), String.t()) :: boolean()
  def has_previous_gameweek_managers?(gameweek, season \\ "25/26") do
    query =
      from m in Manager,
        where: m.gameweek == ^(gameweek - 1) and m.season == ^season,
        select: count()

    Repo.one(query) > 0
  end
end
