defmodule Api_TimeManagerWeb.ClockController do
  use Api_TimeManagerWeb, :controller

  alias Api_TimeManager.Account
  alias Api_TimeManager.Account.Clock

  action_fallback Api_TimeManagerWeb.FallbackController

  def index(conn, _params) do
    clocks = Account.list_clocks()
    render(conn, "index.json", clocks: clocks)
  end

  def create(conn, %{"clock" => clock_params}) do
    with {:ok, %Clock{} = clock} <- Account.create_clock(clock_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.clock_path(conn, :show, clock))
      |> render("show.json", clock: clock)
    end
  end
  def clockByUser(conn, %{"id" => user_d, "clock" => clock_params}) do
    user = Account.get_user!(user_d)
    if (is_nil(user)) do
      conn
      |> put_status(:not_found)
      |> render("error")
    else
      with {:ok, %Clock{} = clock} <- Account.create_clock_for_user(user_d, clock_params) do
       # Account.check_endclock_create_workingtime(clock)
            conn
            |> put_status(:created)
            |> put_resp_header("location", Routes.clock_path(conn, :show, clock))
            |> render("show.json", clock: clock)
      end
    end
  end

  def show(conn, %{"id" => id}) do
    clock = Account.get_clock!(id)
    render(conn, "show.json", clock: clock)
  end

  def update(conn, %{"id" => id, "clock" => clock_params}) do
    clock = Account.get_clock!(id)

    with {:ok, %Clock{} = clock} <- Account.update_clock(clock, clock_params) do
      render(conn, "show.json", clock: clock)
    end
  end

  def delete(conn, %{"id" => id}) do
    clock = Account.get_clock!(id)

    with {:ok, %Clock{}} <- Account.delete_clock(clock) do
      send_resp(conn, :no_content, "")
    end
  end


end
