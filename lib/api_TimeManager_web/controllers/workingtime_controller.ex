defmodule Api_TimeManagerWeb.WorkingtimeController do
  use Api_TimeManagerWeb, :controller

  alias Api_TimeManager.Account
  alias Api_TimeManager.Account.Workingtime

  action_fallback Api_TimeManagerWeb.FallbackController

  def index(conn, _params) do
    workingtimes = Account.list_workingtimes()
    render(conn, "index.json", workingtimes: workingtimes)
  end

  def create(conn, %{"workingtime" => workingtime_params}) do
    with {:ok, %Workingtime{} = workingtime} <- Account.create_workingtime(workingtime_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.workingtime_path(conn, :show, workingtime))
      |> render("show.json", workingtime: workingtime)
    end
  end

  def show(conn, %{"id" => id}) do
    workingtime = Account.get_workingtime_by_user!(id)
    render(conn, "show.json", workingtime: workingtime)
  end

  def update(conn, %{"id" => id, "workingtime" => workingtime_params}) do
    workingtime = Account.get_workingtime!(id)

    with {:ok, %Workingtime{} = workingtime} <- Account.update_workingtime(workingtime, workingtime_params) do
      render(conn, "show.json", workingtime: workingtime)
    end
  end

  def delete(conn, %{"id" => id}) do
    workingtime = Account.get_workingtime!(id)

    with {:ok, %Workingtime{}} <- Account.delete_workingtime(workingtime) do
      send_resp(conn, :no_content, "")
    end
  end

  def getOneById(conn, %{"id" => id, "idwork" => idwork}) do
    worktimes = Account.get_workingtime_by_user!(id)
    Enum.each worktimes, fn workingtime ->   #https://hexdocs.pm/elixir/Enum.html
      if "#{workingtime.id}" == idwork do
        render(conn, "show.json", workingtime: workingtime)
      end
    end
    text conn , "error"
  end


end
