defmodule ClashOfClansFpl.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ClashOfClansFplWeb.Telemetry,
      ClashOfClansFpl.Repo,
      {DNSCluster, query: Application.get_env(:clash_of_clans_fpl, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: ClashOfClansFpl.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: ClashOfClansFpl.Finch},
      # Start a worker by calling: ClashOfClansFpl.Worker.start_link(arg)
      # {ClashOfClansFpl.Worker, arg},
      # Start to serve requests, typically the last entry
      ClashOfClansFplWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ClashOfClansFpl.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ClashOfClansFplWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
