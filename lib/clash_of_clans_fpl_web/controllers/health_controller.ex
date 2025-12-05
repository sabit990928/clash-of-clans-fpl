defmodule ClashOfClansFplWeb.HealthController do
  use ClashOfClansFplWeb, :controller

  @doc """
  Health check endpoint for Fly.io and monitoring.

  Returns JSON with:
  - status: "ok" or "error"
  - scheduler: current scheduler status
  - database: database connection status
  """
  def index(conn, _params) do
    scheduler_status = get_scheduler_status()
    db_status = check_database()

    status = if db_status == :ok, do: "ok", else: "error"

    json(conn, %{
      status: status,
      scheduler: scheduler_status,
      database: db_status,
      timestamp: DateTime.utc_now() |> DateTime.to_iso8601()
    })
  end

  defp get_scheduler_status do
    try do
      ClashOfClansFpl.Scheduler.get_status()
    rescue
      _ -> %{error: "scheduler not available"}
    end
  end

  defp check_database do
    try do
      ClashOfClansFpl.Repo.query!("SELECT 1")
      :ok
    rescue
      _ -> :error
    end
  end
end
