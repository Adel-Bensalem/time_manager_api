defmodule Api_TimeManager.Repo do
  use Ecto.Repo,
    otp_app: :api_TimeManager,
    adapter: Ecto.Adapters.Postgres
end
