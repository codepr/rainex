defmodule Metex.Http.Response do
  @moduledoc false

  @enforce_keys [
    :status,
    :payload,
    :headers
  ]

  defstruct [:status, :payload, :headers]

  @type payload :: String.t() | Enumerable.t()

  @type t :: %__MODULE__{
          status: pos_integer(),
          payload: payload(),
          headers: [tuple()]
        }

  def new(attrs) do
    struct!(__MODULE__, attrs)
  end

  def new(status, payload, headers \\ []) do
    %__MODULE__{status: status, payload: payload, headers: headers}
  end
end
