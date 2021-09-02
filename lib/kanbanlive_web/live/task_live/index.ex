defmodule KanbanliveWeb.TaskLive.Index do
  use KanbanliveWeb, :live_view

  alias Kanbanlive.Tasks
  alias Kanbanlive.Tasks.Task

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket
          |> assign(tasks: list_tasks() |> Kanbanlive.Repo.preload([:owner, :asignee]) )
          |> assign(users: Kanbanlive.Users.list_users())
        }
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Task")
    |> assign(:task, Tasks.get_task!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Task")
    |> assign(:task, %Task{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Tasks")
    |> assign(:task, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    task = Tasks.get_task!(id)
    {:ok, _} = Tasks.delete_task(task)

    {:noreply, assign(socket, :tasks, list_tasks())}
  end

  defp list_tasks do
    Tasks.list_tasks()
  end
end
