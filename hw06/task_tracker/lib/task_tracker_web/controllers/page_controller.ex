defmodule TaskTrackerWeb.PageController do
  use TaskTrackerWeb, :controller

  alias TaskTracker.Job
  alias TaskTracker.Job.Task

  def index(conn, _params) do
    render conn, "index.html"
  end

  def mytasks(conn, _params) do
    tasks = TaskTracker.Job.list_tasks()
    changeset = Job.change_task(%Task{})
    render conn, "mytasks.html", tasks: tasks, changeset: changeset
  end
end
