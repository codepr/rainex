defmodule Rainex.Service.Worker do
  @moduledoc """
  This module implements actual service work.
  It uses a very simple approach. No fancy stuff here.
  Because we only need this worker as a dummy workload to demonstrate how the cluster works.
  """

  use GenServer
  require Logger

  alias Rainex.Monitor
  alias Rainex.Services.OpenWeatherMap

  def start_link(opts) do
    name = Keyword.get(opts, :name, __MODULE__)
    request_params = Keyword.fetch!(opts, :request_params)
    monitor_id = Keyword.fetch!(opts, :monitor_id)

    GenServer.start_link(__MODULE__, {monitor_id, request_params}, name: name)
  end

  @impl true
  def init({monitor_id, request_params}) do
    state = %{monitor_id: monitor_id, request_params: request_params}
    {:ok, state, {:continue, :start}}
  end

  @impl true
  def handle_continue(:start, %{monitor_id: monitor_id} = state) do
    {:ok, persisted_monitor} = Monitor.Repo.fetch(monitor_id)

    {:ok, updated_monitor} =
      persisted_monitor
      |> Monitor.set_pending_state()
      |> Monitor.Repo.upsert()

    schedule_process_loop(updated_monitor)

    log("start: #{inspect(updated_monitor)}")

    {:noreply, Map.put(state, :monitor, updated_monitor)}
  end

  @impl true
  def handle_info(:process, %{monitor: monitor} = state) do
    new_forecast = fetch_forecast(state.request_params)
    frequency = Map.fetch!(monitor, :frequency)
    from_time = Map.fetch!(monitor, :from_time)
    until_time = Map.fetch!(monitor, :until_time)
    monitoring_interval = Timex.Interval.new(from: from_time, until: until_time)
    next_time = Timex.shift(Timex.now(), seconds: frequency)

    {:ok, updated_monitor} =
      monitor
      |> Monitor.set_processing_state()
      |> Monitor.add_forecast(new_forecast)
      |> Monitor.Repo.upsert()

    if next_time in monitoring_interval do
      schedule(:process, frequency)
    else
      schedule(:ready, 0)
    end

    log("process: #{inspect(updated_monitor)}")

    {:noreply, %{state | monitor: updated_monitor}}
  end

  @impl true
  def handle_info(:ready, %{monitor: monitor} = state) do
    {:ok, updated_monitor} =
      monitor
      |> Monitor.set_ready_state()
      |> Monitor.Repo.upsert()

    log("ready: #{inspect(updated_monitor)}")

    {:stop, :normal, %{state | monitor: updated_monitor}}
  end

  defp schedule_process_loop(monitor) do
    from_time = Map.fetch!(monitor, :from_time)
    until_time = Map.fetch!(monitor, :until_time)
    monitoring_interval = Timex.Interval.new(from: from_time, until: until_time)
    current_time = Timex.now()
    next_time = calculate_next_wakup_time(monitor, current_time)

    cond do
      Timex.before?(current_time, from_time) ->
        schedule_timeout = Timex.diff(from_time, current_time, :seconds)
        schedule(:process, schedule_timeout)

      next_time in monitoring_interval ->
        next_current_diff = Timex.diff(next_time, current_time, :seconds)
        schedule_timeout = if next_current_diff > 0, do: next_current_diff, else: 0
        schedule(:process, schedule_timeout)

      true ->
        schedule(:ready, 0)
    end
  end

  defp calculate_next_wakup_time(monitor, current_time) do
    frequency = Map.fetch!(monitor, :frequency)
    forecasts = Map.fetch!(monitor, :forecasts)
    last_forecast = List.first(forecasts)
    last_forecast_time = if last_forecast, do: Map.get(last_forecast, :time)

    next_time =
      if last_forecast_time do
        Timex.shift(last_forecast_time, seconds: frequency)
      else
        current_time
      end

    next_time
  end

  defp schedule(action, timeout_in_seconds) do
    Process.send_after(self(), action, :timer.seconds(timeout_in_seconds))
  end

  defp fetch_forecast(request_params) do
    OpenWeatherMap.forecast(request_params)
  end

  defp log(text) do
    Logger.info("----[#{node()}]----[#{inspect(self())}]---#{text}")
  end
end
