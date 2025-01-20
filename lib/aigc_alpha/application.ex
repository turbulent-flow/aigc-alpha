defmodule AIGCAlpha.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false
  alias AIGCAlpha.TCPServer

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      AIGCAlphaWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:aigc_alpha, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: AIGCAlpha.PubSub},
      # Start a worker by calling: AIGCAlpha.Worker.start_link(arg)
      # {AIGCAlpha.Worker, arg},
      # Start to serve requests, typically the last entry
      AIGCAlphaWeb.Endpoint,
      {Task.Supervisor, name: TCPServer.TaskSupervisor},
      Supervisor.child_spec({Task, fn -> TCPServer.accept(4040) end}, restart: :permanent)
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: AIGCAlpha.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    AIGCAlphaWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
