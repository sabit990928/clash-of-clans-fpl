defmodule ClashOfClansFplWeb.FixtureLive.FormComponent do
  use ClashOfClansFplWeb, :live_component

  alias ClashOfClansFpl.Fixtures

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage fixture records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="fixture-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:team_home_id]} type="number" label="Team home" />
        <.input field={@form[:team_home_score]} type="number" label="Team home score" />
        <.input field={@form[:team_home_name]} type="text" label="Team home name" />
        <.input field={@form[:team_away_id]} type="number" label="Team away" />
        <.input field={@form[:team_away_score]} type="number" label="Team away score" />
        <.input field={@form[:team_away_name]} type="text" label="Team away name" />
        <.input field={@form[:gameweek]} type="number" label="Gameweek" />
        <.input field={@form[:team_h_manager_count]} type="number" label="Team h manager count" />
        <.input field={@form[:team_a_manager_count]} type="number" label="Team a manager count" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Fixture</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{fixture: fixture} = assigns, socket) do
    changeset = Fixtures.change_fixture(fixture)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"fixture" => fixture_params}, socket) do
    changeset =
      socket.assigns.fixture
      |> Fixtures.change_fixture(fixture_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"fixture" => fixture_params}, socket) do
    save_fixture(socket, socket.assigns.action, fixture_params)
  end

  defp save_fixture(socket, :edit, fixture_params) do
    case Fixtures.update_fixture(socket.assigns.fixture, fixture_params) do
      {:ok, fixture} ->
        notify_parent({:saved, fixture})

        {:noreply,
         socket
         |> put_flash(:info, "Fixture updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_fixture(socket, :new, fixture_params) do
    case Fixtures.create_fixture(fixture_params) do
      {:ok, fixture} ->
        notify_parent({:saved, fixture})

        {:noreply,
         socket
         |> put_flash(:info, "Fixture created successfully")
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
