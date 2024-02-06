defmodule ClashOfClansFplWeb.ManagerLiveTest do
  use ClashOfClansFplWeb.ConnCase

  import Phoenix.LiveViewTest
  import ClashOfClansFpl.ManagersFixtures

  @create_attrs %{name: "some name", gameweek: 42, team_name: "some team_name", league_id: 42, team_id: 42, league_name: "some league_name"}
  @update_attrs %{name: "some updated name", gameweek: 43, team_name: "some updated team_name", league_id: 43, team_id: 43, league_name: "some updated league_name"}
  @invalid_attrs %{name: nil, gameweek: nil, team_name: nil, league_id: nil, team_id: nil, league_name: nil}

  defp create_manager(_) do
    manager = manager_fixture()
    %{manager: manager}
  end

  describe "Index" do
    setup [:create_manager]

    test "lists all managers", %{conn: conn, manager: manager} do
      {:ok, _index_live, html} = live(conn, ~p"/managers")

      assert html =~ "Listing Managers"
      assert html =~ manager.name
    end

    test "saves new manager", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/managers")

      assert index_live |> element("a", "New Manager") |> render_click() =~
               "New Manager"

      assert_patch(index_live, ~p"/managers/new")

      assert index_live
             |> form("#manager-form", manager: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#manager-form", manager: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/managers")

      html = render(index_live)
      assert html =~ "Manager created successfully"
      assert html =~ "some name"
    end

    test "updates manager in listing", %{conn: conn, manager: manager} do
      {:ok, index_live, _html} = live(conn, ~p"/managers")

      assert index_live |> element("#managers-#{manager.id} a", "Edit") |> render_click() =~
               "Edit Manager"

      assert_patch(index_live, ~p"/managers/#{manager}/edit")

      assert index_live
             |> form("#manager-form", manager: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#manager-form", manager: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/managers")

      html = render(index_live)
      assert html =~ "Manager updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes manager in listing", %{conn: conn, manager: manager} do
      {:ok, index_live, _html} = live(conn, ~p"/managers")

      assert index_live |> element("#managers-#{manager.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#managers-#{manager.id}")
    end
  end

  describe "Show" do
    setup [:create_manager]

    test "displays manager", %{conn: conn, manager: manager} do
      {:ok, _show_live, html} = live(conn, ~p"/managers/#{manager}")

      assert html =~ "Show Manager"
      assert html =~ manager.name
    end

    test "updates manager within modal", %{conn: conn, manager: manager} do
      {:ok, show_live, _html} = live(conn, ~p"/managers/#{manager}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Manager"

      assert_patch(show_live, ~p"/managers/#{manager}/show/edit")

      assert show_live
             |> form("#manager-form", manager: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#manager-form", manager: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/managers/#{manager}")

      html = render(show_live)
      assert html =~ "Manager updated successfully"
      assert html =~ "some updated name"
    end
  end
end
