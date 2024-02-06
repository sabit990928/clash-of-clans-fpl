defmodule ClashOfClansFpl.Fixtures do
  @moduledoc """
  The Fixtures context.
  """

  import Ecto.Query, warn: false
  alias ClashOfClansFpl.Repo

  alias ClashOfClansFpl.Fixtures.Fixture

  @doc """
  Returns the list of fixtures.

  ## Examples

      iex> list_fixtures()
      [%Fixture{}, ...]

  """
  def list_fixtures do
    Repo.all(Fixture)
  end

  @doc """
  Gets a single fixture.

  Raises `Ecto.NoResultsError` if the Fixture does not exist.

  ## Examples

      iex> get_fixture!(123)
      %Fixture{}

      iex> get_fixture!(456)
      ** (Ecto.NoResultsError)

  """
  def get_fixture!(id), do: Repo.get!(Fixture, id)

  @doc """
  Creates a fixture.

  ## Examples

      iex> create_fixture(%{field: value})
      {:ok, %Fixture{}}

      iex> create_fixture(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_fixture(attrs \\ %{}) do
    %Fixture{}
    |> Fixture.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a fixture.

  ## Examples

      iex> update_fixture(fixture, %{field: new_value})
      {:ok, %Fixture{}}

      iex> update_fixture(fixture, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_fixture(%Fixture{} = fixture, attrs) do
    fixture
    |> Fixture.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a fixture.

  ## Examples

      iex> delete_fixture(fixture)
      {:ok, %Fixture{}}

      iex> delete_fixture(fixture)
      {:error, %Ecto.Changeset{}}

  """
  def delete_fixture(%Fixture{} = fixture) do
    Repo.delete(fixture)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking fixture changes.

  ## Examples

      iex> change_fixture(fixture)
      %Ecto.Changeset{data: %Fixture{}}

  """
  def change_fixture(%Fixture{} = fixture, attrs \\ %{}) do
    Fixture.changeset(fixture, attrs)
  end

  def get_fixtures_with_hits(gameweek) do
    fixtures = from(f in Fixture, where: f.gameweek == ^gameweek) |> Repo.all()

    Enum.map(fixtures, fn fixture ->
      {"#{fixture.team_home_name} #{fixture.team_h_avg_hits |> Float.round(3)} — #{fixture.team_a_avg_hits |> Float.round(3)} #{fixture.team_away_name}"}
    end)
  end
end
