defmodule Metex do
  @moduledoc """
  Documentation for `Metex`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Metex.get_forecast(["London", "Berlin"])
      :world

  """
  use Application

  @impl true
  def start(_type, _args) do
    children = [{Task.Supervisor, name: Metex.TaskSupervisor}]
    Supervisor.start_link(children, strategy: :one_for_one, name: Metex.Supervisor)
  end

  defdelegate get_forecast(locations), to: Metex.Coordinator
  defdelegate temperature_of(locations), to: Metex.Coordinator
end
