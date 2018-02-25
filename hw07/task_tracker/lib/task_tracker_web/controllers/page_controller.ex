defmodule TaskTrackerWeb.PageController do
  use TaskTrackerWeb, :controller

  alias TaskTracker.Account
  alias TaskTracker.Account.Manage
  alias TaskTracker.Accounts
  alias TaskTracker.Accounts.User
  alias TaskTracker.Job
  alias TaskTracker.Job.Task

  def index(conn, _params) do
    render conn, "index.html"
  end

  def profile(conn, _params) do
    current_user = conn.assigns[:current_user]
    users = Accounts.list_users()
    managees = Account.get_managees(current_user)

    managee_users = Account.get_managee_user(current_user)
    |> Enum.map(fn(x)-> Accounts.get_user!(x.managee_id) end)

    manager_users = Account.get_manager_user(current_user)
    |> Enum.map(fn(x)-> Accounts.get_user!(x.manager_id) end)

    changeset = Job.change_task(%Task{})
    render(conn, "profile.html", users: users, managees: managees, manager_users: manager_users, managee_users: managee_users, changeset: changeset)
  end

end
