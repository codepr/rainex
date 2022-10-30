defmodule Rainex.Services.Behaviour do
  @moduledoc false

  @callback get_forecast(map()) :: {:ok, map()} | {:error, any()}
end
