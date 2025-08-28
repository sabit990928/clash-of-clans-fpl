defmodule ClashOfClansFpl.Scheduler do
  use GenServer

  alias ClashOfClansFpl.Standings

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(state) do
    schedule_task()
    {:ok, state}
  end

  def handle_info(:run_task, state) do
    IO.puts("Task is running at #{DateTime.utc_now()}")
    # run_task()
    {:noreply, state}
  end

  defp schedule_task do
    # Set your target time here
    IO.inspect("Task is scheduled at #{DateTime.utc_now()}")
    delay = calculate_delay()
    # Process.send_after(self(), :run_task, delay)
  end

  def run_task do
    IO.puts("Task function is running at #{DateTime.utc_now()}")

    gameweek = 19

    # 1:
    IO.inspect(Standings.list_duplicate_managers(), label: "Standings.list_duplicate_managers()")

    # 2:
    IO.inspect("Saving gameweek league managers...")
    Standings.save_gameweek_league_managers(gameweek)

    # 3:
    IO.inspect("Saving gameweek fixtures...")
    averages = Standings.save_gameweek_fixtures(gameweek)
    IO.inspect(averages, label: "fixtures")

    # 4:
    IO.inspect("Updating positions...")
    Standings.update_positions()

    # 5. Another optional:
    IO.inspect("Calculating median points...")
    medians = Standings.calculate_median_points(gameweek)
    IO.inspect(medians, label: "medians")

    # 6:
    IO.inspect("Generating CSV...")
    ClashOfClansFpl.ClashCSV.generate_csv_with_headers(gameweek)
  end

  def calculate_delay() do
    current_time = DateTime.utc_now()

    target_time =
      DateTime.new!(~D[2024-12-16], ~T[03:32:00])

    delay = DateTime.diff(target_time, current_time, :millisecond)

    # Ensure the delay is not negative
    max(delay, 0)
  end
end
