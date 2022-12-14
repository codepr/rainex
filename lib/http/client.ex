defmodule Rainex.Http.Client do
  @moduledoc false
  @behaviour Rainex.Http.Behaviour

  alias Rainex.Http.Response

  @impl true
  def get(endpoint, headers \\ [], opts \\ []) do
    case HTTPoison.get(endpoint, headers, opts) do
      {:ok, %{body: body, status_code: status_code, headers: headers}} ->
        {:ok, Response.new(%{payload: body, status: status_code, headers: headers})}

      error ->
        error
    end
  end
end
