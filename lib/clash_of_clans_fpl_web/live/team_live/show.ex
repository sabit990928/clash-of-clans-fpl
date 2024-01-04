defmodule ClashOfClansFplWeb.TeamLive.Show do
  use ClashOfClansFplWeb, :live_view

  alias ClashOfClansFpl.Standings

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:team, Standings.get_team!(id))}
  end

  defp page_title(:show), do: "Show Team"
  defp page_title(:edit), do: "Edit Team"
end
