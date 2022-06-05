defmodule Metex.Worker do
  def loop do
    receive do
      {sender_pid, location} ->
        send(sender_pid, {:ok, temperature_of(location)})

      _ ->
        IO.puts("don't know how to process this message")
    end
  end

  def temperature_of(location) do
    result = url_for(location) |> HTTPoison.get() |> parse_response

    case result do
      {:ok, temp} -> "#{location}: #{temp} C"
      :error -> "#{location} not found"
    end
  end

  defp url_for(location) do
    location = URI.encode(location)
    "https://api.openweathermap.org/data/2.5/weather?q=#{location}&apiid=#{apikey}"
  end

  defp parse_response({:ok, %HTTPoison.Response{body: body, status_code: 200}}) do
    body |> JSON.decode!() |> compute_temperature
  end

  defp parse_response(_) do
    :error
  end

  defp compute_temperature(json) do
    try do
      temp = (json["main"]["temp"] - 273.15) |> Float.round(1)
      {:ok, temp}
    rescue
      _ -> :error
    end
  end

  defp apikey do
    "63efae3f1d695118d00585ae1fa82283"
  end
end
