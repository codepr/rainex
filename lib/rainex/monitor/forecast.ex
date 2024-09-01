defmodule Rainex.Monitor.Forecast do
  @moduledoc false

  defmodule Temperature do
    @moduledoc false

    @derive Jason.Encoder

    @typep t :: %__MODULE__{
             temp: String.t(),
             temp_min: String.t(),
             temp_max: String.t(),
             unit: temperature_unit()
           }

    @type temperature_unit :: :celsius | :farenheit

    @enforce_keys [:temp, :temp_min, :temp_max, :unit]

    defstruct [:temp, :temp_min, :temp_max, :unit]

    @spec new(map(), temperature_unit()) :: t()
    def new(params, temp_unit) do
      ["temp", "temp_min", "temp_max"]
      |> Map.new(fn key -> {key, convert_temperature(Map.get(params, key), temp_unit)} end)
      |> Map.put("temp_unit", temp_unit)
    end

    defp convert_temperature(temperature, :celsius) do
      (temperature - 273.15) |> Float.round(1)
    end

    defp convert_temperature(temperature, _unit), do: temperature
  end

  defmodule Weather do
    @moduledoc false

    @derive Jason.Encoder

    @typep t :: %__MODULE__{
             sunrise: String.t(),
             sunset: String.t(),
             wind: String.t(),
             temperature: Temperature.t()
           }

    @enforce_keys [:sunrise, :sunset, :wind, :temperature]

    defstruct [:sunrise, :sunset, :wind, :temperature]

    @spec new(String.t(), String.t(), String.t(), map(), Temperature.temperature_unit()) :: t()
    def new(sunrise, sunset, wind, temperature_params, temp_unit) do
      %__MODULE__{
        sunrise: sunrise,
        sunset: sunset,
        wind: wind,
        temperature: Temperature.new(temperature_params, temp_unit)
      }
    end
  end

  @type t :: %__MODULE__{
          time: DateTime.t(),
          location: String.t(),
          country: String.t(),
          weather: Weather.t()
        }

  @enforce_keys [:time, :location, :country, :weather]

  @derive Jason.Encoder

  defstruct [:time, :location, :country, :weather]

  @spec new(map(), Temperature.temperature_unit()) :: t()
  def new(params, temp_unit) do
    %__MODULE__{
      time: Timex.now(),
      location: params["name"],
      country: params["sys"]["country"],
      weather:
        Weather.new(
          params["sys"]["sunrise"],
          params["sys"]["sunset"],
          params["wind"],
          params["main"],
          temp_unit
        )
    }
  end
end
