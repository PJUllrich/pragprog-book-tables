defmodule MeowWeb.PageController do
  use MeowWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
