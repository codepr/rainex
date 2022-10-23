defmodule Metex.Client.OpenWeatherMap do
  @behaviour Metex.Client.Behaviour

  alias Metex.Http.Response

  @url "https://api.openweathermap.org/data/2.5"

  @impl true
  def get_forecast(%{location: location}) do
    url_for(location) |> http_client().get() |> parse_response
  end

  defp parse_response({:ok, %Response{payload: payload, status: 200}}) do
    payload
    |> JSON.decode!()
    |> compute_response()
  end

  defp parse_response(_) do
    :error
  end

  defp url_for(location) do
    location = URI.encode(location)
    @url <> "/weather?q=#{location}&appid=#{apikey()}"
  end

  defp apikey, do: "63efae3f1d695118d00585ae1fa82283"

  defp convert_temperature(temperature, :celsius) do
    (temperature - 273.15) |> Float.round(1)
  end

  defp compute_response(response, opts \\ []) do
    temp_unit = Keyword.get(opts, :temp_unit, :celsius)

    temperature_map =
      ["temp", "temp_min", "temp_max"]
      |> Enum.map(fn key ->
        {key, convert_temperature(Map.get(response["main"], key), temp_unit)}
      end)
      |> Enum.into(%{"temp_unit" => temp_unit})

    {:ok,
     %{
       location: response["name"],
       country: response["sys"]["country"],
       weather: %{
         sunrise: response["sys"]["sunrise"],
         sunset: response["sys"]["sunset"],
         wind: response["wind"],
         temperature: temperature_map
       }
     }}
  rescue
    error -> {:error, error}
  end

  defp http_client, do: Application.get_env(:metex, :http_client, Metex.Http.Client)
end
