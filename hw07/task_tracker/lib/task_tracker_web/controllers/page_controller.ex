defmodule TaskTrackerWeb.PageController do
  use TaskTrackerWeb, :controller

  alias TaskTracker.Accounts
  alias TaskTracker.Accounts.User
  alias TaskTracker.Job
  alias TaskTracker.Job.Task

  def index(conn, _params) do
    render conn, "index.html"
  end

  def profile(conn, _params) do
    users = Accounts.list_users()
    changeset = Job.change_task(%Task{})
    render(conn, "profile.html", users: users, changeset: changeset)
  end

end
