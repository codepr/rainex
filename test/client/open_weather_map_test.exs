defmodule Rainex.Services.OpenWeatherMapTest do
  @moduledoc false
  use ExUnit.Case, async: true

  import Mox, only: [expect: 3, verify_on_exit!: 1]

  alias Rainex.Services.OpenWeatherMap
  alias Rainex.Http.ClientMock
  alias Rainex.Http.Response

  setup :verify_on_exit!

  describe "OpenWeatherMap.get_forecast/1" do
    test "returns a map with forecasts" do
      expect(ClientMock, :get, fn endpoint ->
        assert endpoint =~ "https://api.openweathermap.org/data/2.5/"

        {:ok,
         %Response{
           status: 200,
           headers: [],
           payload:
             JSON.encode!(%{
               "base" => "stations",
               "clouds" => %{"all" => 75},
               "cod" => 200,
               "coord" => %{"lat" => 35.6895, "lon" => 139.6917},
               "dt" => 1_666_459_800,
               "id" => 1_850_144,
               "main" => %{
                 "feels_like" => 290.11,
                 "humidity" => 82,
                 "pressure" => 1013,
                 "temp" => 290.21,
                 "temp_max" => 290.68,
                 "temp_min" => 286.73
               },
               "name" => "Tokyo",
               "sys" => %{
                 "country" => "JP",
                 "id" => 8074,
                 "sunrise" => 1_666_472_047,
                 "sunset" => 1_666_511_811,
                 "type" => 1
               },
               "timezone" => 32_400,
               "visibility" => 10_000,
               "weather" => [
                 %{
                   "description" => "broken clouds",
                   "icon" => "04n",
                   "id" => 803,
                   "main" => "Clouds"
                 }
               ],
               "wind" => %{"deg" => 50, "speed" => 2.06}
             })
         }}
      end)

      assert {:ok,
              %{
                country: "JP",
                location: "Tokyo",
                weather: %{
                  sunrise: 1_666_472_047,
                  sunset: 1_666_511_811,
                  temperature: %{
                    "temp" => 17.1,
                    "temp_max" => 17.5,
                    "temp_min" => 13.6,
                    "temp_unit" => :celsius
                  },
                  wind: %{"deg" => 50, "speed" => 2.06}
                }
              }} = OpenWeatherMap.get_forecast(%{location: "Tokyo"})
    end
  end
end
