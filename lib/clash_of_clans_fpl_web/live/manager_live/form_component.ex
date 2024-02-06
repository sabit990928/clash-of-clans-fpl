defmodule ClashOfClansFplWeb.ManagerLive.FormComponent do
  use ClashOfClansFplWeb, :live_component

  alias ClashOfClansFpl.Managers

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage manager records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="manager-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:gameweek]} type="number" label="Gameweek" />
        <.input field={@form[:team_name]} type="text" label="Team name" />
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:league_id]} type="number" label="League" />
        <.input field={@form[:team_id]} type="number" label="Team" />
        <.input field={@form[:league_name]} type="text" label="League name" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Manager</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{manager: manager} = assigns, socket) do
    changeset = Managers.change_manager(manager)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"manager" => manager_params}, socket) do
    changeset =
      socket.assigns.manager
      |> Managers.change_manager(manager_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"manager" => manager_params}, socket) do
    save_manager(socket, socket.assigns.action, manager_params)
  end

  defp save_manager(socket, :edit, manager_params) do
    case Managers.update_manager(socket.assigns.manager, manager_params) do
      {:ok, manager} ->
        notify_parent({:saved, manager})

        {:noreply,
         socket
         |> put_flash(:info, "Manager updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_manager(socket, :new, manager_params) do
    case Managers.create_manager(manager_params) do
      {:ok, manager} ->
        notify_parent({:saved, manager})

        {:noreply,
         socket
         |> put_flash(:info, "Manager created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
