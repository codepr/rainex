defmodule Rainex.Application do
  @moduledoc false
  use Application

  def start(_type, _args) do
    children = [
      {Cluster.Supervisor, [topologies(), [name: Rainex.ClusterSupervisor]]},
      {
        Horde.Registry,
        name: Rainex.ClusterRegistry, keys: :unique, members: :auto
      },
      {
        Horde.DynamicSupervisor,
        name: Rainex.ClusterServiceSupervisor, strategy: :one_for_one, members: :auto
      },
      Rainex.Monitor.Repo,
      {
        Plug.Cowboy,
        scheme: :http,
        plug: Rainex.Endpoint,
        options: [port: String.to_integer(System.get_env("PORT") || "4000")]
      }
    ]

    opts = [strategy: :one_for_one, name: Rainex.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Can also read this from conf files, but to keep it simple just hardcode it for now.
  # It is also possible to use different strategies for autodiscovery.
  # Following strategy works best for docker setup we using for this app.
  defp topologies do
    [
      weather_monitor_service: [
        strategy: Cluster.Strategy.Epmd,
        config: [
          hosts: [
            :"app@n1.dev",
            :"app@n2.dev",
            :"app@n3.dev"
          ]
        ]
      ]
    ]
  end
end
