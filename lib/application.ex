defmodule Rainex.Application do
  @moduledoc false
  use Application

  def start(_type, _args) do
    children = [{Task.Supervisor, name: Rainex.TaskSupervisor}]
    Supervisor.start_link(children, strategy: :one_for_one, name: Rainex.Supervisor)
  end
end
