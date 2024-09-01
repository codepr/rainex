defmodule Rainex.Services.Behaviour do
  @moduledoc false

  @callback forecast(map()) :: {:ok, map()} | {:error, any()}
end
