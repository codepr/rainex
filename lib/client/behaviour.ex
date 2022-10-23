defmodule Metex.Client.Behaviour do
  alias Metex.Forecast

  @callback get_forecast(map()) :: {:ok, Forecast.t()} | {:error, any()}
end
