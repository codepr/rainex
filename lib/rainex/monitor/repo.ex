defmodule Rainex.Monitor.Repo do
  @moduledoc false
  use Nebulex.Cache,
    otp_app: :rainex,
    adapter: Nebulex.Adapters.Replicated

  alias Rainex.Monitor

  @spec fetch(String.t()) :: {:error, :not_found} | {:ok, any}
  def fetch(id) do
    case get(id) do
      nil ->
        {:error, :not_found}

      monitor ->
        {:ok, monitor}
    end
  end

  @spec upsert(Monitor.t()) :: {:ok, Monitor.t()}
  def upsert(%Monitor{id: id} = monitor) do
    :ok = put(id, monitor)

    {:ok, monitor}
  end

  @spec remove(Monitor.t()) :: {:ok, Monitor.t()}
  def remove(%Monitor{id: id} = monitor) do
    :ok = delete(id)

    {:ok, monitor}
  end
end
