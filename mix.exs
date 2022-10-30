defmodule Metex.MixProject do
  use Mix.Project

  def project do
    [
      app: :metex,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {Metex, []},
      extra_applications: [:logger, :json],
      applications: [:logger, :httpoison]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 1.8"},
      {:json, "~> 1.4"},
      {:credo, "~> 1.4"},
      {:mox, "~> 1.0.2", only: :test}
    ]
  end
end
