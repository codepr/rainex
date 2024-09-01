defmodule Rainex do
  @moduledoc """
  Documentation for `Rainex`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Rainex.forecast(["London", "Berlin"])
      :world

  """

  # use Application
  #
  # @impl true
  # def start(_type, _args) do
  #   children = [{Task.Supervisor, name: Rainex.TaskSupervisor}]
  #   Supervisor.start_link(children, strategy: :one_for_one, name: Rainex.Supervisor)
  # end

  def hello, do: :hello
end
