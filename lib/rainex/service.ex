defmodule Rainex.Service do
  @moduledoc false

  alias Rainex.ClusterRegistry
  alias Rainex.ClusterServiceSupervisor
  alias Rainex.Monitor
  alias Rainex.Monitor.Repo
  alias Rainex.Service.Worker

  @spec start(keyword) :: {:ok, Monitor.t()} | :error
  def start(params) do
    with {:ok, new_monitor} <- Monitor.new(params),
         {:ok, monitor} <- Repo.upsert(new_monitor),
         {:ok, locations} <- Keyword.fetch(params, :locations),
         child_specs <- worker_specs(monitor, locations),
         _children <- start_children(child_specs) do
      {:ok, monitor}
    else
      _ -> :error
    end
  end

  defp start_children(child_specs) do
    Enum.map(child_specs, &Horde.DynamicSupervisor.start_child(ClusterServiceSupervisor, &1))
  end

  defp worker_specs(%Monitor{id: monitor_id}, locations) do
    Enum.map(locations, &worker_spec(monitor_id, &1))
  end

  defp worker_spec(monitor_id, location) do
    %{
      id: {Worker, monitor_id},
      start:
        {Worker, :start_link,
         [
           [
             monitor_id: monitor_id,
             request_params: %{location: location},
             name: via_tuple(monitor_id, location)
           ]
         ]},
      type: :worker,
      restart: :transient
    }
  end

  defp via_tuple(id, location) do
    {:via, Horde.Registry, {ClusterRegistry, {Monitor, "#{id}#{location}"}}}
  end
end
