defmodule OthelloWeb.PageController do
  use OthelloWeb, :controller
  alias Othello.Game

  def enter(conn, params) do
    render conn, "enter.html", game: params["game"]
  end

  def index(conn, _params) do
    games = Game.collectGames
    render conn, "index.html", games: games
  end

  def game(conn, params) do
    presentGame = Game.currentStatus params["game"]
    user_name = get_session(conn, :user_name)
    if presentGame do
      players = presentGame.players
      if Kernel.length(players) == 2 || user_name && String.length(user_name) > 0 do
        render conn, "game.html", game: params["game"]
      else
        render conn, "enter.html", game: params["game"]
      end
    else
      if user_name && String.length(user_name) > 0 do
        render conn, "game.html", game: params["game"]
      else
        render conn, "enter.html", game: params["game"]
      end
    end
  end

  def room(conn, _params) do
    games = Game.collectGames
    render conn, "room.html", games: games
  end
end
