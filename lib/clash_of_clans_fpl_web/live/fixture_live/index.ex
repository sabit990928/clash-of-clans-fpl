defmodule ClashOfClansFplWeb.FixtureLive.Index do
  use ClashOfClansFplWeb, :live_view

  alias ClashOfClansFpl.Fixtures
  alias ClashOfClansFpl.Fixtures.Fixture

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :fixtures, Fixtures.list_fixtures())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Fixture")
    |> assign(:fixture, Fixtures.get_fixture!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Fixture")
    |> assign(:fixture, %Fixture{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Fixtures")
    |> assign(:fixture, nil)
  end

  @impl true
  def handle_info({ClashOfClansFplWeb.FixtureLive.FormComponent, {:saved, fixture}}, socket) do
    {:noreply, stream_insert(socket, :fixtures, fixture)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    fixture = Fixtures.get_fixture!(id)
    {:ok, _} = Fixtures.delete_fixture(fixture)

    {:noreply, stream_delete(socket, :fixtures, fixture)}
  end
end
