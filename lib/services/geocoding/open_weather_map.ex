defmodule Rainex.Services.Geocoding.OpenWeatherMap do
  @moduledoc false

  alias Rainex.Http.Response

  @url "https://api.openweathermap.org/geo/1.0"

  def get_coordinates(city) do
    url_for(city) |> http_client().get() |> parse_response
  end

  defp parse_response({:ok, %Response{payload: payload, status: 200}}) do
    payload
    |> JSON.decode!()
    |> compute_response()
  end

  defp parse_response(_) do
    :error
  end

  defp compute_response(response) do
    {:ok, Enum.map(response, fn record ->
      %{"country" => country, "lat" => lat, "lon" => lon} = record
      %{country: country, coordinates: {lat, lon}}
    end)}
  rescue
    error -> {:error, error}
  end

  defp url_for(location) do
    location = URI.encode(location)
    @url <> "/direct?q=#{location}&appid=#{apikey()}"
  end

  defp apikey, do: Application.get_env(:rainex, :owm_token)

  defp http_client, do: Application.get_env(:rainex, :http_client)
end
