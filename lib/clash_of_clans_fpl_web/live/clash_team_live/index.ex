defmodule ClashOfClansFplWeb.ClashTeamLive.Index do
  use ClashOfClansFplWeb, :live_view

  alias ClashOfClansFpl.Standings
  alias ClashOfClansFpl.Standings.Team

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :teams, Standings.list_teams())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Team")
    |> assign(:team, Standings.get_team!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Team")
    |> assign(:team, %Team{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Teams")
    |> assign(:team, nil)
  end

  @impl true
  def handle_info({ClashOfClansFplWeb.TeamLive.FormComponent, {:saved, team}}, socket) do
    {:noreply, stream_insert(socket, :teams, team)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    team = Standings.get_team!(id)
    {:ok, _} = Standings.delete_team(team)

    {:noreply, stream_delete(socket, :teams, team)}
  end
end
