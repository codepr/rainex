defmodule Metex do
  @moduledoc """
  Documentation for `Metex`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Metex.hello()
      :world

  """
  # def temperature_of(cities) do
  #   coordinator_pid = spawn(Metex.Coordinator, :loop, [[], Enum.count(cities)])

  #   cities
  #   |> Enum.each(fn city ->
  #     worker_pid = spawn(Metex.Worker, :loop, [])
  #     send(worker_pid, {coordinator_pid, city})
  #     Metex.Worker.get_stats(worker_pid)
  #   end)
  # end
end
