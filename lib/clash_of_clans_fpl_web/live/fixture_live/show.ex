defmodule ClashOfClansFplWeb.FixtureLive.Show do
  use ClashOfClansFplWeb, :live_view

  alias ClashOfClansFpl.Fixtures

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:fixture, Fixtures.get_fixture!(id))}
  end

  defp page_title(:show), do: "Show Fixture"
  defp page_title(:edit), do: "Edit Fixture"
end
