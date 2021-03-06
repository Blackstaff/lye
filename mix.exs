defmodule Lye.Mixfile do
  use Mix.Project

  def project do
    [app: :lye,
     version: "0.1.0",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger, :sweet_xml, :elixir_xml_to_map, :xml_builder,
      :httpoison, :iteraptor],
     mod: {Lye, []}]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:sweet_xml, "~> 0.6.2"},
      {:elixir_xml_to_map, "~> 0.1.1"},
      {:xml_builder, "~> 0.0.8"},
      {:httpoison, "~> 0.11"},
      {:iteraptor, "~> 0.7.0"},

      # Docs dependencies
      {:ex_doc, "~> 0.14", only: :docs},
      {:inch_ex, "~> 0.5", only: :docs},

      # Code analysis dependencies
      {:credo, "~> 0.3", only: [:dev, :test]},
      {:dialyxir, "~> 0.4", only: [:dev]}
    ]
  end
end
