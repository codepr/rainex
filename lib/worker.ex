defmodule Metex.Worker do
  # use GenServer

  # alias Metex.Client.OpenWeatherMap

  # @name MW

  # ## Client API

  # def start_link(opts \\ []) do
  #   GenServer.start_link(__MODULE__, :ok, opts ++ [name: @name])
  # end

  # def get_temperature(_pid, location) do
  #   GenServer.call(@name, {:location, location})
  # end

  # def get_stats(_pid) do
  #   GenServer.call(@name, :get_stats)
  # end

  # def reset_stats(_pid) do
  #   GenServer.cast(@name, :reset_stats)
  # end

  # def stop(_pid) do
  #   GenServer.cast(@name, :stop)
  # end

  # def terminate(reason, stats) do
  #   IO.puts("server terminated because of #{inspect(reason)}")
  #   inspect(stats)
  #   :ok
  # end

  # ##  Server Callbacks

  # def init(:ok) do
  #   {:ok, %{}}
  # end

  # def loop do
  #   receive do
  #     {coordinator_pid, :stats} -> send(coordinator_pid, get_stats(coordinator_pid))
  #     {coordinator_pid, city} -> get_temperature(coordinator_pid, city)
  #   end
  # end

  # def handle_call({:location, location}, _from, stats) do
  #   case temperature_of(location) do
  #     {:ok, temp} ->
  #       new_stats = update_stats(stats, location)
  #       {:reply, "#{temp} C", new_stats}

  #     _ ->
  #       {:reply, :error, stats}
  #   end
  # end

  # def handle_call(:get_stats, _from, stats) do
  #   {:reply, stats, stats}
  # end

  # def handle_cast(:reset_stats, _stats) do
  #   {:noreply, %{}}
  # end

  # def handle_cast(:stop, _stats) do
  #   {:stop, :normal, :ok, :stats}
  # end

  # def handle_info(msg, stats) do
  #   IO.puts("received #{inspect(msg)}")
  #   {:noreply, stats}
  # end

  # ## Helper Functions

  # def temperature_of(location) do
  #   case OpenWeatherMap.get_forecast(%{location: location}) do
  #     {:ok, forecast} -> {:ok, forecast.weather[:temp]}
  #     error -> error
  #   end
  # end

  # defp update_stats(old_stats, location) do
  #   case Map.has_key?(old_stats, location) do
  #     true -> Map.update!(old_stats, location, &(&1 + 1))
  #     false -> Map.put_new(old_stats, location, 1)
  #   end
  # end
end
