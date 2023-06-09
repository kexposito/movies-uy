defmodule MoviesUy.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      MoviesUy.Repo,
      # Start the Telemetry supervisor
      MoviesUyWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: MoviesUy.PubSub},
      # Start the Endpoint (http/https)
      MoviesUyWeb.Endpoint,
      # Start a worker by calling: MoviesUy.Worker.start_link(arg)
      # {MoviesUy.Worker, arg}
      {Finch, name: MoviesUyFinch},
      {Oban, Application.fetch_env!(:movies_uy, Oban)}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: MoviesUy.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    MoviesUyWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
