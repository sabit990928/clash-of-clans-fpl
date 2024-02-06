defmodule ClashOfClansFplWeb.ManagerLive.Index do
  use ClashOfClansFplWeb, :live_view

  alias ClashOfClansFpl.Managers
  alias ClashOfClansFpl.Managers.Manager

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :managers, Managers.list_managers())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Manager")
    |> assign(:manager, Managers.get_manager!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Manager")
    |> assign(:manager, %Manager{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Managers")
    |> assign(:manager, nil)
  end

  @impl true
  def handle_info({ClashOfClansFplWeb.ManagerLive.FormComponent, {:saved, manager}}, socket) do
    {:noreply, stream_insert(socket, :managers, manager)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    manager = Managers.get_manager!(id)
    {:ok, _} = Managers.delete_manager(manager)

    {:noreply, stream_delete(socket, :managers, manager)}
  end
end
