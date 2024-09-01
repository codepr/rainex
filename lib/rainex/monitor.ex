defmodule Rainex.Monitor do
  @moduledoc false

  alias Rainex.Monitor.Forecast

  @pending_state :pending
  @processing_state :processing
  @ready_state :ready

  @type state :: :pending | :processing | :ready

  @type t :: %__MODULE__{
          id: String.t(),
          state: state(),
          frequency: Integer.t(),
          from_time: DateTime.t(),
          until_time: DateTime.t(),
          forecasts: [Forecast.t()]
        }

  @enforce_keys [:id, :state, :frequency, :from_time, :until_time]

  @derive {Jason.Encoder, only: [:id, :state, :forecasts]}

  defstruct [
    :id,
    :state,
    :frequency,
    :from_time,
    :until_time,
    forecasts: []
  ]

  @spec new(keyword) :: {:ok, t()} | :error
  def new(params) do
    with {:ok, period} <- Keyword.fetch(params, :period),
         valid_period when is_integer(period) <- period,
         {:ok, frequency} <- Keyword.fetch(params, :frequency),
         valid_frequency when is_integer(frequency) <- frequency,
         from_time <- Timex.now(),
         until_time <- Timex.shift(from_time, seconds: valid_period) do
      monitor = %__MODULE__{
        id: UUID.uuid1(),
        state: @pending_state,
        frequency: valid_frequency,
        from_time: from_time,
        until_time: until_time
      }

      {:ok, monitor}
    else
      _ -> :error
    end
  end

  @spec merge_monitors(t(), t()) :: t()
  def merge_monitors(monitor_a, monitor_b) do
    %{
      monitor_a
      | forecasts:
          (monitor_a.forecasts ++ monitor_b.forecasts)
          |> MapSet.new()
          |> MapSet.to_list()
    }
  end

  @spec add_forecast(t(), Forecast.t()) :: t()
  def add_forecast(%__MODULE__{forecasts: old_forecasts} = monitor, %Forecast{} = new_forecast) do
    %{monitor | forecasts: [new_forecast | old_forecasts]}
  end

  @spec set_pending_state(t()) :: t()
  def set_pending_state(%__MODULE__{} = monitor), do: %{monitor | state: @pending_state}

  @spec set_processing_state(t()) :: t()
  def set_processing_state(%__MODULE__{} = monitor), do: %{monitor | state: @processing_state}

  @spec set_ready_state(t()) :: t()
  def set_ready_state(%__MODULE__{} = monitor), do: %{monitor | state: @ready_state}
end
