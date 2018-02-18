defmodule TaskTrackerWeb.PageController do
  use TaskTrackerWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def mytasks(conn, _params) do
    tasks = TaskTracker.Job.list_tasks()
    #assign(conn, :tasks, tasks)
    render conn, "mytasks.html", tasks: tasks
  end
end
