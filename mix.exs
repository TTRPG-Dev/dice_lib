defmodule DiceLib.MixProject do
  use Mix.Project

  def project do
    [
      app: :dice_lib,
      version: "0.1.0",
      elixir: "~> 1.19",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package(),
      name: "DiceLib",
      source_url: "https://github.com/TTRPG-Dev/dice_lib",
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end

  defp description do
    "DiceLib is a library for rolling dice. Is it the best? Eh, it's a roll of the dice"
  end

  defp package do
    [
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/TTRPG-Dev/dice_lib"}
    ]
  end
end
