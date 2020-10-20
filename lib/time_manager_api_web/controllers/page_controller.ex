defmodule TimeManagerApiWeb.PageController do
  use TimeManagerApiWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
