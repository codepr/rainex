defmodule Metex.Coordinator do
  @moduledoc false
  alias Metex.Services.OpenWeatherMap
  def get_forecast(locations) do
    locations
    |> Enum.map(fn location ->
      Task.Supervisor.async_nolink(Metex.TaskSupervisor, fn ->
        OpenWeatherMap.get_forecast(%{location: location})
      end)
    end)
    |> Enum.map(&Task.await/1)
  end
end
