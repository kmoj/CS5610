defmodule TaskTrackerWeb.SessionController do
  use TaskTrackerWeb, :controller

  alias TaskTracker.Accounts
  alias TaskTracker.Accounts.User

  def create(conn, %{"email" => email}) do

    IO.puts(email)
    user = Accounts.get_user_by_email(email)

    if user do
      conn
      |> put_session(:user_id, user.id)
      |> put_flash(:info, "Hi, #{user.name}")
      |> redirect(to: page_path(conn, :mytasks))
    else
      conn
      |> put_flash(:error, "Email not found")
      |> redirect(to: page_path(conn, :index))
    end
  end

  def delete(conn, _params) do
    conn
    |> delete_session(:user_id)
    |> put_flash(:info, "Logged out")
    |> redirect(to: page_path(conn, :index))
  end

end
