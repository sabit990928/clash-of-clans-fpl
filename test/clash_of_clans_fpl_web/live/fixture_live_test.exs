defmodule ClashOfClansFplWeb.FixtureLiveTest do
  use ClashOfClansFplWeb.ConnCase

  import Phoenix.LiveViewTest
  import ClashOfClansFpl.FixturesFixtures

  @create_attrs %{team_home_id: 42, team_home_score: 42, team_home_name: "some team_home_name", team_away_id: 42, team_away_score: 42, team_away_name: "some team_away_name", gameweek: 42, team_h_manager_count: 42, team_a_manager_count: 42}
  @update_attrs %{team_home_id: 43, team_home_score: 43, team_home_name: "some updated team_home_name", team_away_id: 43, team_away_score: 43, team_away_name: "some updated team_away_name", gameweek: 43, team_h_manager_count: 43, team_a_manager_count: 43}
  @invalid_attrs %{team_home_id: nil, team_home_score: nil, team_home_name: nil, team_away_id: nil, team_away_score: nil, team_away_name: nil, gameweek: nil, team_h_manager_count: nil, team_a_manager_count: nil}

  defp create_fixture(_) do
    fixture = fixture_fixture()
    %{fixture: fixture}
  end

  describe "Index" do
    setup [:create_fixture]

    test "lists all fixtures", %{conn: conn, fixture: fixture} do
      {:ok, _index_live, html} = live(conn, ~p"/fixtures")

      assert html =~ "Listing Fixtures"
      assert html =~ fixture.team_home_name
    end

    test "saves new fixture", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/fixtures")

      assert index_live |> element("a", "New Fixture") |> render_click() =~
               "New Fixture"

      assert_patch(index_live, ~p"/fixtures/new")

      assert index_live
             |> form("#fixture-form", fixture: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#fixture-form", fixture: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/fixtures")

      html = render(index_live)
      assert html =~ "Fixture created successfully"
      assert html =~ "some team_home_name"
    end

    test "updates fixture in listing", %{conn: conn, fixture: fixture} do
      {:ok, index_live, _html} = live(conn, ~p"/fixtures")

      assert index_live |> element("#fixtures-#{fixture.id} a", "Edit") |> render_click() =~
               "Edit Fixture"

      assert_patch(index_live, ~p"/fixtures/#{fixture}/edit")

      assert index_live
             |> form("#fixture-form", fixture: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#fixture-form", fixture: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/fixtures")

      html = render(index_live)
      assert html =~ "Fixture updated successfully"
      assert html =~ "some updated team_home_name"
    end

    test "deletes fixture in listing", %{conn: conn, fixture: fixture} do
      {:ok, index_live, _html} = live(conn, ~p"/fixtures")

      assert index_live |> element("#fixtures-#{fixture.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#fixtures-#{fixture.id}")
    end
  end

  describe "Show" do
    setup [:create_fixture]

    test "displays fixture", %{conn: conn, fixture: fixture} do
      {:ok, _show_live, html} = live(conn, ~p"/fixtures/#{fixture}")

      assert html =~ "Show Fixture"
      assert html =~ fixture.team_home_name
    end

    test "updates fixture within modal", %{conn: conn, fixture: fixture} do
      {:ok, show_live, _html} = live(conn, ~p"/fixtures/#{fixture}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Fixture"

      assert_patch(show_live, ~p"/fixtures/#{fixture}/show/edit")

      assert show_live
             |> form("#fixture-form", fixture: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#fixture-form", fixture: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/fixtures/#{fixture}")

      html = render(show_live)
      assert html =~ "Fixture updated successfully"
      assert html =~ "some updated team_home_name"
    end
  end
end
