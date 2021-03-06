defmodule TaskTrackerWeb.TimeblockController do
  use TaskTrackerWeb, :controller

  alias TaskTracker.Job
  alias TaskTracker.Job.Timeblock

  action_fallback TaskTrackerWeb.FallbackController

  def index(conn, _params) do
    timeblocks = Job.list_timeblocks()
    render(conn, "index.json", timeblocks: timeblocks)
  end

  def create(conn, %{"timeblock" => timeblock_params}) do
#    case Job.create_timeblock(timeblock_params) do
#      {:ok, %Timeblock{} = timeblock} ->
#        conn
#        |> put_status(:created)
#        |> put_flash(:info, "User created successfully.")
#        |> put_resp_header("location", timeblock_path(conn, :show, timeblock))
#        |> render("show.json", timeblock: timeblock)
#      {:error, %Timeblock{} = timeblock} ->
#        render(conn, TaskTrackerWeb.PageView, "editForm.html")
#    end
    with {:ok, %Timeblock{} = timeblock} <- Job.create_timeblock(timeblock_params)  do
      conn
      |> put_status(:created)
      |> put_resp_header("location", timeblock_path(conn, :show, timeblock))
      |> render("show.json", timeblock: timeblock)
    end
  end

  def show(conn, %{"id" => id}) do
    timeblock = Job.get_timeblock!(id)
    render(conn, "show.json", timeblock: timeblock)
  end

  def update(conn, %{"id" => id, "timeblock" => timeblock_params}) do
    timeblock = Job.get_timeblock!(id)

    with {:ok, %Timeblock{} = timeblock} <- Job.update_timeblock(timeblock, timeblock_params) do
      render(conn, "show.json", timeblock: timeblock)
    end
  end

  def delete(conn, %{"id" => id}) do
    timeblock = Job.get_timeblock!(id)
    with {:ok, %Timeblock{}} <- Job.delete_timeblock(timeblock) do
      send_resp(conn, :no_content, "")
    end
  end
end
