defmodule RainexTest do
  @moduledoc false
  use ExUnit.Case, async: true

  import Mox, only: [expect: 3, verify_on_exit!: 1]

  alias Rainex
  alias Rainex.Http.ClientMock
  alias Rainex.Http.Response

  setup :verify_on_exit!

  describe "Rainex.temperature_of/1" do
    test "returns temperature of a single location" do
      expect(ClientMock, :get, fn endpoint ->
        assert endpoint =~ "https://api.openweathermap.org/data/2.5/"

        {:ok,
         %Response{
           status: 200,
           headers: [],
           payload:
             Jason.encode!(%{
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

      assert %{"Tokyo" => 17.1} = Rainex.temperature_of(["Tokyo"])
    end
  end
end
