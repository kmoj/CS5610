defmodule TaskTracker.Account do
  @moduledoc """
  The Account context.
  """

  import Ecto.Query, warn: false
  alias TaskTracker.Repo

  alias TaskTracker.Account.Manage

  @doc """
  Returns the list of manages.

  ## Examples

      iex> list_manages()
      [%Manage{}, ...]

  """
  def list_manages do
    Repo.all(Manage)
  end

  @doc """
  Gets a single manage.

  Raises `Ecto.NoResultsError` if the Manage does not exist.

  ## Examples

      iex> get_manage!(123)
      %Manage{}

      iex> get_manage!(456)
      ** (Ecto.NoResultsError)

  """
  def get_manage!(id), do: Repo.get!(Manage, id)

  def get_managees(user) do
    Repo.all(from m in Manage,
             where: m.manager_id == ^user.id)
    |> Enum.map(&({&1.managee_id, &1.id}))
    |> Enum.into(%{})
  end

  def get_managee_user(user) do
    Repo.all(from m in Manage,
             where: m.manager_id == ^user.id)
  end

  def get_managers(user) do
    Repo.all(from m in Manage,
             where: m.managee_id == ^user.id)
    |> Enum.map(&({&1.manager_id, &1.id}))
    |> Enum.into(%{})
  end

  def get_manager_user(user) do
    Repo.all(from m in Manage,
             where: m.managee_id == ^user.id)
  end

  @doc """
  Creates a manage.

  ## Examples

      iex> create_manage(%{field: value})
      {:ok, %Manage{}}

      iex> create_manage(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_manage(attrs \\ %{}) do
    %Manage{}
    |> Manage.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a manage.

  ## Examples

      iex> update_manage(manage, %{field: new_value})
      {:ok, %Manage{}}

      iex> update_manage(manage, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_manage(%Manage{} = manage, attrs) do
    manage
    |> Manage.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Manage.

  ## Examples

      iex> delete_manage(manage)
      {:ok, %Manage{}}

      iex> delete_manage(manage)
      {:error, %Ecto.Changeset{}}

  """
  def delete_manage(%Manage{} = manage) do
    Repo.delete(manage)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking manage changes.

  ## Examples

      iex> change_manage(manage)
      %Ecto.Changeset{source: %Manage{}}

  """
  def change_manage(%Manage{} = manage) do
    Manage.changeset(manage, %{})
  end
end
