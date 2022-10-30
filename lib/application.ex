defmodule Metex.Application do
  @moduledoc false
  use Application

  def start(_type, _args) do
    children = [{Task.Supervisor, name: Metex.TaskSupervisor}]
    Supervisor.start_link(children, strategy: :one_for_one, name: Metex.Supervisor)
  end
end
