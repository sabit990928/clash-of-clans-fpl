defmodule ClashOfClansFpl.FplApi do
  @moduledoc """
  Client for interacting with the Fantasy Premier League API.

  Used by the scheduler to determine when gameweeks end and when to run calculations.
  """

  require Logger

  @base_url "https://fantasy.premierleague.com/api"
  # 90 min game + 30 min buffer
  @game_duration_minutes 120

  @doc """
  Fetches the current gameweek information from the FPL bootstrap API.

  Returns {:ok, map} with:
  - gameweek: current gameweek number
  - finished: whether the gameweek has finished
  - data_checked: whether FPL has confirmed the data
  - deadline_time: deadline for the gameweek

  Returns {:error, reason} on failure.
  """
  @spec get_current_gameweek() :: {:ok, map()} | {:error, term()}
  def get_current_gameweek do
    case HTTPoison.get("#{@base_url}/bootstrap-static/") do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        data = Jason.decode!(body)
        events = data["events"]

        current = Enum.find(events, & &1["is_current"])

        if current do
          {:ok,
           %{
             gameweek: current["id"],
             finished: current["finished"],
             data_checked: current["data_checked"],
             deadline_time: current["deadline_time"]
           }}
        else
          {:error, :no_current_gameweek}
        end

      {:ok, %HTTPoison.Response{status_code: status}} ->
        {:error, {:http_error, status}}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  @doc """
  Fetches fixtures for a gameweek and returns information about the last fixture.

  Returns {:ok, map} with:
  - last_kickoff: DateTime of the last kickoff
  - estimated_end: DateTime when the last game is estimated to end
  - all_finished: whether all fixtures are marked as finished
  - fixture_count: number of fixtures in the gameweek

  Returns {:error, reason} on failure.
  """
  @spec get_gameweek_last_fixture_time(integer()) :: {:ok, map()} | {:error, term()}
  def get_gameweek_last_fixture_time(gameweek) do
    case HTTPoison.get("#{@base_url}/fixtures/?event=#{gameweek}") do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        fixtures = Jason.decode!(body)

        if Enum.empty?(fixtures) do
          {:error, :no_fixtures}
        else
          # Find the latest kickoff time
          kickoff_times =
            fixtures
            |> Enum.map(& &1["kickoff_time"])
            # Remove nil values
            |> Enum.filter(& &1)

          if Enum.empty?(kickoff_times) do
            {:error, :no_kickoff_times}
          else
            latest_kickoff = Enum.max(kickoff_times)

            # Parse and add game duration
            {:ok, kickoff_dt, _} = DateTime.from_iso8601(latest_kickoff)
            end_time = DateTime.add(kickoff_dt, @game_duration_minutes, :minute)

            # Check if all fixtures are finished
            all_finished = Enum.all?(fixtures, & &1["finished"])

            {:ok,
             %{
               last_kickoff: kickoff_dt,
               estimated_end: end_time,
               all_finished: all_finished,
               fixture_count: length(fixtures)
             }}
          end
        end

      {:ok, %HTTPoison.Response{status_code: status}} ->
        {:error, {:http_error, status}}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  @doc """
  Checks if all fixtures in a gameweek are finished.
  Returns true if finished, false otherwise (including on error).
  """
  @spec gameweek_finished?(integer()) :: boolean()
  def gameweek_finished?(gameweek) do
    case get_gameweek_last_fixture_time(gameweek) do
      {:ok, %{all_finished: finished}} -> finished
      _ -> false
    end
  end

  @doc """
  Gets the average points for a gameweek from the bootstrap-static endpoint.
  Useful for verification purposes.
  """
  @spec get_average_points(integer()) :: {:ok, float()} | {:error, term()}
  def get_average_points(gameweek) do
    case HTTPoison.get("#{@base_url}/bootstrap-static/") do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        data = Jason.decode!(body)
        events = data["events"]

        event = Enum.find(events, &(&1["id"] == gameweek))

        if event do
          {:ok, event["average_entry_score"]}
        else
          {:error, :gameweek_not_found}
        end

      {:ok, %HTTPoison.Response{status_code: status}} ->
        {:error, {:http_error, status}}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end
end
