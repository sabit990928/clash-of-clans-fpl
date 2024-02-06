defmodule ClashOfClansFplWeb.ManagerLive.Show do
  use ClashOfClansFplWeb, :live_view

  alias ClashOfClansFpl.Managers

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:manager, Managers.get_manager!(id))}
  end

  defp page_title(:show), do: "Show Manager"
  defp page_title(:edit), do: "Edit Manager"
end
