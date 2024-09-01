defmodule Rainex.MixProject do
  use Mix.Project

  def project do
    [
      app: :rainex,
      version: "0.1.0",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {Rainex.Application, []},
      extra_applications: [:logger],
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:libcluster, "~> 3.3"},
      {:horde, "~> 0.9"},
      {:uuid, "~> 1.1"},
      {:nebulex, "~> 2.6.3"},
      {:timex, "~> 3.7.11"},
      {:plug_cowboy, "~> 2.7.1"},
      {:jason, "~> 1.4.4"},
      {:httpoison, "~> 2.2.1"},
      {:credo, "~> 1.7.7"},
      {:mox, "~> 1.2.0", only: :test}
    ]
  end
end
