defmodule Rainex do
  @moduledoc """
  Documentation for `Rainex`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Rainex.get_forecast(["London", "Berlin"])
      :world

  """
  use Application

  @impl true
  def start(_type, _args) do
    children = [{Task.Supervisor, name: Rainex.TaskSupervisor}]
    Supervisor.start_link(children, strategy: :one_for_one, name: Rainex.Supervisor)
  end

  defdelegate get_forecast(locations), to: Rainex.Coordinator
  defdelegate temperature_of(locations), to: Rainex.Coordinator
end
