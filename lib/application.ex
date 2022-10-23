defmodule Metex do
  use Application

  def start(_type, _args) do
    children = [Metex.Worker]
    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
