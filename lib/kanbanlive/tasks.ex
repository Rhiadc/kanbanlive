defmodule Kanbanlive.Tasks do
  @moduledoc """
  The Tasks context.
  """

  import Ecto.Query, warn: false
  alias Kanbanlive.Repo
  alias Kanbanlive.Users
  alias Kanbanlive.Tasks.Task

  @doc """
  Returns the list of tasks.

  ## Examples

      iex> list_tasks()
      [%Task{}, ...]

  """
  def list_tasks do
    Repo.all(Task)
  end

  @doc """
  Gets a single task.

  Raises `Ecto.NoResultsError` if the Task does not exist.

  ## Examples

      iex> get_task!(123)
      %Task{}

      iex> get_task!(456)
      ** (Ecto.NoResultsError)

  """
  def get_task!(id), do: Repo.get!(Task, id)

  @doc """
  Creates a task.

  ## Examples

      iex> create_task(%{field: value})
      {:ok, %Task{}}

      iex> create_task(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def insert_task(attrs \\ %{}) do
    %Task{}
    |> Task.changeset(attrs)
    |> Repo.insert()
  end

  def create_task(owner_id, asignee_id, attrs) do
    owner = Users.get_user!(owner_id)
    asignee = Users.get_user!(asignee_id)

    {:ok, task} = attrs
    |> build_assoc(owner, :owned_tasks)
    |> build_assoc(asignee, :assigned_tasks)
    |> Task.changeset(attrs)
    |> Repo.insert()
    {:ok, task |> Repo.preload([:owner, :asignee])}

  end

  def build_assoc(task, owner_or_asignee, :owned_tasks) do
    Ecto.build_assoc(owner_or_asignee, :owned_tasks, task)
  end

  def build_assoc(task, owner_or_asignee, :assigned_tasks) do
    Ecto.build_assoc(owner_or_asignee, :assigned_tasks, task)
  end

  @doc """
  Updates a task.

  ## Examples

      iex> update_task(task, %{field: new_value})
      {:ok, %Task{}}

      iex> update_task(task, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_task(%Task{} = task, attrs) do

   task
    |> Task.changeset(attrs)
    |> Repo.update()

  end

  @doc """
  Deletes a task.

  ## Examples

      iex> delete_task(task)
      {:ok, %Task{}}

      iex> delete_task(task)
      {:error, %Ecto.Changeset{}}

  """
  def delete_task(%Task{} = task) do
    Repo.delete(task)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking task changes.

  ## Examples

      iex> change_task(task)
      %Ecto.Changeset{data: %Task{}}

  """
  def change_task(%Task{} = task, attrs \\ %{}) do
    Task.changeset(task, attrs)
  end
end
