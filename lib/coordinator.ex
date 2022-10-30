defmodule Rainex.Coordinator do
  @moduledoc false
  alias Rainex.Services.OpenWeatherMap

  def get_forecast(locations) do
    locations
    |> Enum.map(fn location ->
      Task.Supervisor.async_nolink(Rainex.TaskSupervisor, fn ->
        OpenWeatherMap.get_forecast(%{location: location})
      end)
    end)
    |> Enum.map(&Task.await/1)
  end

  def temperature_of(locations) do
    get_forecast(locations)
    |> Enum.map(&extract_temperature/1)
    |> Enum.into(%{})
  end

  defp extract_temperature({:ok, forecast}) do
    %{location: location, weather: weather} = forecast
    %{temperature: temperature} = weather
    {location, temperature["temp"]}
  end

  defp extract_temperature(error), do: error
end
