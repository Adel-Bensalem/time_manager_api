defmodule Api_TimeManagerWeb.Router do
  use Api_TimeManagerWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    #plug :fetch_session
    #plug :fetch_flash
    #plug :protect_from_forgery
    #plug :put_secure_browser_headers
  end

  scope "/api", Api_TimeManagerWeb do
    pipe_through :api
    # USERS
    resources "/users", UserController, except: [:new, :edit]
    # CLOCKS
    resources "/clocks", ClockController, except: [:new, :edit]
    post "/clocks/:id", ClockController, :clockByUser  #To add a clock for user, for later change it for Auth
    # WORKINGTIMES
    resources "/workingtimes", WorkingtimeController, except: [:new, :edit]
    get "/workingtimes/:id/:idwork", WorkingtimeController, :getOneById
    post "/workingtimes/:id", WorkingtimeController, :workingtimeByUser
  end
end
