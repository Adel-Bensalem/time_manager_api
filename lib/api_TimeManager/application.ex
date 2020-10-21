defmodule Api_TimeManager.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Api_TimeManager.Repo,
      # Start the Telemetry supervisor
      Api_TimeManagerWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Api_TimeManager.PubSub},
      # Start the Endpoint (http/https)
      Api_TimeManagerWeb.Endpoint
      # Start a worker by calling: Api_TimeManager.Worker.start_link(arg)
      # {Api_TimeManager.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Api_TimeManager.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    Api_TimeManagerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
