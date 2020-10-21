defmodule Api_TimeManagerWeb.PageController do
  use Api_TimeManagerWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
