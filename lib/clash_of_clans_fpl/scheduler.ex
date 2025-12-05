defmodule ClashOfClansFpl.Scheduler do
  @moduledoc """
  Automated gameweek processing scheduler.

  Dynamically schedules processing based on FPL fixture times:
  1. On startup, checks current gameweek status from FPL API
  2. If gameweek not finished, schedules check for after last game + 7 hours
  3. When triggered, runs the appropriate pipeline (regular or second_half)
  4. After success, schedules next gameweek check

  The scheduler is only enabled when ENABLE_SCHEDULER=true environment variable
  is set (typically only in production).
  """

  use GenServer
  require Logger

  alias ClashOfClansFpl.FplApi
  alias ClashOfClansFpl.PipelineDetector
  alias ClashOfClansFpl.Standings
  alias ClashOfClansFpl.SecondHalf
  alias ClashOfClansFpl.ClashCSV

  @hours_after_last_game 7
  @retry_delay_minutes 30
  @max_retries 3
  @check_interval_hours 1

  defstruct [
    :current_gameweek,
    :scheduled_time,
    :timer_ref,
    :retry_count,
    :last_processed_gw,
    :status
  ]

  # Public API

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %__MODULE__{}, name: __MODULE__)
  end

  @doc """
  Manually trigger processing for a specific gameweek.
  Useful for testing or re-running failed gameweeks.
  """
  @spec trigger_processing(integer()) :: :ok
  def trigger_processing(gameweek) do
    GenServer.cast(__MODULE__, {:manual_trigger, gameweek})
  end

  @doc """
  Get the current status of the scheduler.
  """
  @spec get_status() :: map()
  def get_status do
    GenServer.call(__MODULE__, :get_status)
  end

  @doc """
  Force a check for the current gameweek status.
  """
  @spec force_check() :: :ok
  def force_check do
    GenServer.cast(__MODULE__, :force_check)
  end

  # GenServer callbacks

  @impl true
  def init(_opts) do
    # Always start with a fresh struct
    state = %__MODULE__{status: :initializing, retry_count: 0}

    if scheduler_enabled?() do
      Logger.info("[Scheduler] Starting in enabled mode")
      # Delay initial check slightly to allow app to fully start
      Process.send_after(self(), :check_and_schedule, 5_000)
      {:ok, %{state | status: :waiting}}
    else
      Logger.info(
        "[Scheduler] Disabled in this environment (set ENABLE_SCHEDULER=true to enable)"
      )

      {:ok, %{state | status: :disabled}}
    end
  end

  @impl true
  def handle_info(:check_and_schedule, state) do
    Logger.info("[Scheduler] Checking gameweek status...")

    case FplApi.get_current_gameweek() do
      {:ok, %{gameweek: gw, finished: finished, data_checked: data_checked}} ->
        Logger.info(
          "[Scheduler] Current GW: #{gw}, finished: #{finished}, data_checked: #{data_checked}"
        )

        new_state = handle_gameweek_status(state, gw, finished, data_checked)
        {:noreply, new_state}

      {:error, reason} ->
        Logger.error("[Scheduler] Failed to get current gameweek: #{inspect(reason)}")
        # Retry after delay
        timer_ref = schedule_message(:check_and_schedule, hours_to_ms(@check_interval_hours))
        {:noreply, %{state | timer_ref: timer_ref, status: :error}}
    end
  end

  @impl true
  def handle_info(:run_processing, state) do
    Logger.info("[Scheduler] Starting gameweek #{state.current_gameweek} processing...")

    case run_gameweek_pipeline(state.current_gameweek) do
      :ok ->
        Logger.info(
          "[Scheduler] Gameweek #{state.current_gameweek} processing completed successfully!"
        )

        new_state = %{
          state
          | last_processed_gw: state.current_gameweek,
            retry_count: 0,
            status: :completed
        }

        # Schedule check for next gameweek after a delay
        timer_ref = schedule_message(:check_and_schedule, hours_to_ms(@check_interval_hours))
        {:noreply, %{new_state | timer_ref: timer_ref}}

      {:error, reason} ->
        Logger.error("[Scheduler] Processing failed: #{inspect(reason)}")
        handle_processing_failure(state, reason)
    end
  end

  @impl true
  def handle_info(:verify_and_process, state) do
    Logger.info("[Scheduler] Verifying gameweek #{state.current_gameweek} is finished...")

    # Double-check that gameweek is actually finished before processing
    case FplApi.get_current_gameweek() do
      {:ok, %{gameweek: gw, finished: true, data_checked: true}}
      when gw == state.current_gameweek ->
        Logger.info(
          "[Scheduler] GW#{gw} confirmed finished with data checked, starting processing..."
        )

        send(self(), :run_processing)
        {:noreply, state}

      {:ok, %{finished: true, data_checked: false}} ->
        Logger.info(
          "[Scheduler] GW finished but data not yet confirmed, rechecking in 30 minutes..."
        )

        timer_ref = schedule_message(:verify_and_process, minutes_to_ms(30))
        {:noreply, %{state | timer_ref: timer_ref}}

      {:ok, _} ->
        Logger.info(
          "[Scheduler] GW#{state.current_gameweek} not yet finished, rechecking in 1 hour..."
        )

        timer_ref = schedule_message(:verify_and_process, hours_to_ms(1))
        {:noreply, %{state | timer_ref: timer_ref}}

      {:error, reason} ->
        Logger.error(
          "[Scheduler] Error checking GW status: #{inspect(reason)}, retrying in 1 hour..."
        )

        timer_ref = schedule_message(:verify_and_process, hours_to_ms(1))
        {:noreply, %{state | timer_ref: timer_ref}}
    end
  end

  @impl true
  def handle_cast({:manual_trigger, gameweek}, state) do
    Logger.info("[Scheduler] Manual trigger for gameweek #{gameweek}")
    # Cancel any existing timer
    if state.timer_ref, do: Process.cancel_timer(state.timer_ref)

    new_state = %{
      state
      | current_gameweek: gameweek,
        retry_count: 0,
        status: :processing,
        timer_ref: nil
    }

    send(self(), :run_processing)
    {:noreply, new_state}
  end

  @impl true
  def handle_cast(:force_check, state) do
    Logger.info("[Scheduler] Force check requested")
    if state.timer_ref, do: Process.cancel_timer(state.timer_ref)
    send(self(), :check_and_schedule)
    {:noreply, %{state | timer_ref: nil}}
  end

  @impl true
  def handle_call(:get_status, _from, state) do
    status = %{
      enabled: scheduler_enabled?(),
      status: state.status,
      current_gameweek: state.current_gameweek,
      scheduled_time: format_datetime(state.scheduled_time),
      last_processed_gw: state.last_processed_gw,
      retry_count: state.retry_count
    }

    {:reply, status, state}
  end

  # Private functions

  defp handle_gameweek_status(state, gameweek, finished, data_checked) do
    cond do
      # Already processed this gameweek
      state.last_processed_gw == gameweek ->
        Logger.info("[Scheduler] GW#{gameweek} already processed, waiting for next gameweek...")
        timer_ref = schedule_message(:check_and_schedule, hours_to_ms(6))
        %{state | timer_ref: timer_ref, status: :waiting_next_gw}

      # Gameweek finished and data confirmed - process now
      finished and data_checked ->
        Logger.info(
          "[Scheduler] GW#{gameweek} finished and data confirmed, starting processing..."
        )

        send(self(), :run_processing)
        %{state | current_gameweek: gameweek, retry_count: 0, status: :processing}

      # Gameweek finished but data not yet confirmed - verify soon
      finished ->
        Logger.info(
          "[Scheduler] GW#{gameweek} finished but data not confirmed yet, checking again in 30 mins..."
        )

        timer_ref = schedule_message(:verify_and_process, minutes_to_ms(30))
        %{state | current_gameweek: gameweek, timer_ref: timer_ref, status: :waiting_data_check}

      # Gameweek in progress - schedule for after last game
      true ->
        schedule_for_after_gameweek(state, gameweek)
    end
  end

  defp schedule_for_after_gameweek(state, gameweek) do
    case FplApi.get_gameweek_last_fixture_time(gameweek) do
      {:ok, %{estimated_end: end_time, fixture_count: count}} ->
        # Schedule for 7 hours after last game ends
        process_time = DateTime.add(end_time, @hours_after_last_game, :hour)
        now = DateTime.utc_now()

        delay_ms = max(DateTime.diff(process_time, now, :millisecond), 0)
        hours_until = Float.round(delay_ms / 3_600_000, 1)

        Logger.info("[Scheduler] GW#{gameweek} has #{count} fixtures")
        Logger.info("[Scheduler] Last game ends: #{format_datetime(end_time)}")

        Logger.info(
          "[Scheduler] Scheduling processing for: #{format_datetime(process_time)} (in #{hours_until}h)"
        )

        timer_ref = schedule_message(:verify_and_process, delay_ms)

        %{
          state
          | current_gameweek: gameweek,
            scheduled_time: process_time,
            timer_ref: timer_ref,
            status: :scheduled
        }

      {:error, reason} ->
        Logger.error("[Scheduler] Failed to get fixture times: #{inspect(reason)}")
        timer_ref = schedule_message(:check_and_schedule, hours_to_ms(@check_interval_hours))
        %{state | timer_ref: timer_ref, status: :error}
    end
  end

  defp run_gameweek_pipeline(gameweek) do
    pipeline = PipelineDetector.detect_pipeline(gameweek)
    Logger.info("[Scheduler] Using #{pipeline} pipeline for GW#{gameweek}")
    Logger.info("[Scheduler] #{PipelineDetector.describe_pipeline(gameweek)}")

    try do
      case pipeline do
        :regular -> run_regular_pipeline(gameweek)
        :second_half -> run_second_half_pipeline(gameweek)
      end
    rescue
      e ->
        Logger.error("[Scheduler] Pipeline error: #{Exception.message(e)}")
        Logger.error("[Scheduler] #{Exception.format_stacktrace(__STACKTRACE__)}")
        {:error, e}
    end
  end

  defp run_regular_pipeline(gameweek) do
    Logger.info("[Scheduler] Step 1/5: Checking for duplicate managers...")
    duplicates = Standings.list_duplicate_managers()
    Logger.info("[Scheduler] Found #{map_size(duplicates)} duplicate managers")

    Logger.info("[Scheduler] Step 2/5: Saving gameweek league managers...")
    Standings.save_gameweek_league_managers(gameweek)

    Logger.info("[Scheduler] Step 3/5: Saving gameweek fixtures...")
    Standings.save_gameweek_fixtures(gameweek)

    Logger.info("[Scheduler] Step 4/5: Updating positions...")
    Standings.update_positions()

    Logger.info("[Scheduler] Step 5/5: Generating CSV files...")
    ClashCSV.generate_csv_with_headers(gameweek)

    Logger.info("[Scheduler] Regular pipeline completed for GW#{gameweek}")
    :ok
  end

  defp run_second_half_pipeline(gameweek) do
    # Verify previous GW has managers
    if not PipelineDetector.has_previous_gameweek_managers?(gameweek) do
      Logger.warning(
        "[Scheduler] No managers found for GW#{gameweek - 1}, falling back to regular pipeline"
      )

      run_regular_pipeline(gameweek)
    else
      Logger.info("[Scheduler] Step 1/4: Copying managers from GW#{gameweek - 1}...")
      SecondHalf.copy_gw_managers_from_previous(gameweek)

      Logger.info("[Scheduler] Step 2/4: Saving local gameweek fixtures...")
      SecondHalf.local_save_gameweek_fixtures(gameweek)

      Logger.info("[Scheduler] Step 3/4: Updating positions...")
      Standings.update_positions()

      Logger.info("[Scheduler] Step 4/4: Generating CSV files...")
      ClashCSV.generate_csv_with_headers(gameweek)

      Logger.info("[Scheduler] SecondHalf pipeline completed for GW#{gameweek}")
      :ok
    end
  end

  defp handle_processing_failure(state, _reason) do
    new_retry_count = state.retry_count + 1

    if new_retry_count <= @max_retries do
      Logger.info(
        "[Scheduler] Retrying in #{@retry_delay_minutes} minutes (attempt #{new_retry_count}/#{@max_retries})..."
      )

      timer_ref = schedule_message(:run_processing, minutes_to_ms(@retry_delay_minutes))
      {:noreply, %{state | retry_count: new_retry_count, timer_ref: timer_ref, status: :retrying}}
    else
      Logger.error(
        "[Scheduler] Max retries (#{@max_retries}) exceeded for GW#{state.current_gameweek}"
      )

      # Schedule next check anyway
      timer_ref = schedule_message(:check_and_schedule, hours_to_ms(@check_interval_hours))
      {:noreply, %{state | timer_ref: timer_ref, retry_count: 0, status: :failed}}
    end
  end

  defp schedule_message(message, delay_ms) do
    Process.send_after(self(), message, trunc(delay_ms))
  end

  defp scheduler_enabled? do
    System.get_env("ENABLE_SCHEDULER") == "true" ||
      Application.get_env(:clash_of_clans_fpl, :enable_scheduler, false)
  end

  defp hours_to_ms(hours), do: hours * 60 * 60 * 1000
  defp minutes_to_ms(minutes), do: minutes * 60 * 1000

  defp format_datetime(nil), do: nil

  defp format_datetime(%DateTime{} = dt) do
    Calendar.strftime(dt, "%Y-%m-%d %H:%M:%S UTC")
  end
end
