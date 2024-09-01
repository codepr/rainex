defmodule Rainex.Services.OpenWeatherMap do
  @moduledoc false
  @behaviour Rainex.Services.Behaviour

  alias Rainex.Http.Response
  alias Rainex.Monitor.Forecast

  @url "https://api.openweathermap.org/data/2.5"

  @impl true
  def forecast(%{location: location}) do
    url_for(location) |> http_client().get() |> parse_response
  end

  defp parse_response({:ok, %Response{payload: payload, status: 200}}) do
    payload
    |> Jason.decode!()
    |> compute_response()
  end

  defp parse_response(_) do
    :error
  end

  defp url_for(location) do
    location = URI.encode(location)
    @url <> "/weather?q=#{location}&appid=#{apikey()}"
  end

  defp apikey, do: Application.get_env(:rainex, :owm_token)

  defp compute_response(response) do
    {:ok, Forecast.new(response, :celsius)}
  rescue
    error -> {:error, error}
  end

  defp http_client, do: Application.get_env(:rainex, :http_client)
end
