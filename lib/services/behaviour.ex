defmodule Metex.Services.Behaviour do
  @moduledoc false
  alias Metex.Forecast

  @callback get_forecast(map()) :: {:ok, Forecast.t()} | {:error, any()}
end
