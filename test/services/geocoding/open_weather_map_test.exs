defmodule Rainex.Services.Geocoding.OpenWeatherMapTest do
  @moduledoc false
  use ExUnit.Case, async: true

  import Mox, only: [expect: 3, verify_on_exit!: 1]

  alias Decimal
  alias Rainex.Http.ClientMock
  alias Rainex.Http.Response
  alias Rainex.Services.Geocoding.OpenWeatherMap

  setup :verify_on_exit!

  describe "OpenWeatherMap.get_coordinates/1" do
    test "returns a map with coordinates" do
      expect(ClientMock, :get, fn endpoint ->
        assert endpoint =~ "https://api.openweathermap.org/geo/1.0/"

        {:ok,
         %Response{
           status: 200,
           headers: [],
           payload:
             Jason.encode!([
               %{
                 "country" => "GB",
                 "lat" => 51.5073219,
                 "local_names" => %{
                   "tk" => "London",
                   "uz" => "London"
                 },
                 "lon" => -0.12764,
                 "name" => "London",
                 "state" => "England"
               }
             ])
         }}
      end)

      assert {:ok,
              [
                %{
                  country: "GB",
                  coordinates: {51.5073219, -0.12764}
                }
              ]} = OpenWeatherMap.get_coordinates("London")
    end
  end
end
