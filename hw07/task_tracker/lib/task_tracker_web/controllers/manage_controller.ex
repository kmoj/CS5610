defmodule TaskTrackerWeb.ManageController do
  use TaskTrackerWeb, :controller

  alias TaskTracker.Account
  alias TaskTracker.Account.Manage
  alias TaskTracker.Accounts
  alias TaskTracker.Accounts.User
  alias TaskTracker.Job
  alias TaskTracker.Job.Task

  action_fallback TaskTrackerWeb.FallbackController

  def index(conn, _params) do
    manages = Account.list_manages()
    render(conn, "index.json", manages: manages)
  end

  def create(conn, %{"manage" => manage_params}) do
    with {:ok, %Manage{} = manage} <- Account.create_manage(manage_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", manage_path(conn, :show, manage))
      |> render("show.json", manage: manage)
    end
  end

  def show(conn, %{"id" => id}) do
    manage = Account.get_manage!(id)
    render(conn, "show.json", manage: manage)
  end

  def update(conn, %{"id" => id, "manage" => manage_params}) do
    manage = Account.get_manage!(id)

    with {:ok, %Manage{} = manage} <- Account.update_manage(manage, manage_params) do
      render(conn, "show.json", manage: manage)
    end
  end

  def delete(conn, %{"id" => id}) do
    manage = Account.get_manage!(id)
    assignee = Accounts.get_user!(manage.managee_id)
    tasks = Job.get_uncomplete_tasks_by_assigner_assignee(manage.manager_id, assignee.name)
    |> Enum.map( fn(x)-> Job.delete_task(x) end)

    with {:ok, %Manage{}} <- Account.delete_manage(manage) do
      send_resp(conn, :no_content, "")
    end
  end
end
