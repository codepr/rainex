defmodule Rainex.Http.Behaviour do
  @moduledoc """
  Behaviour to enable mocking of the http client.
  """

  alias Rainex.Http.Response

  @callback get(String.t(), Keyword.t(), Keyword.t()) :: {:ok, Response.t()} | {:error, any()}
  @callback get(String.t(), Keyword.t()) :: {:ok, Response.t()} | {:error, any()}
  @callback get(String.t()) :: {:ok, Response.t()} | {:error, any()}
end
