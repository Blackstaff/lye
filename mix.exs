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
    [applications: [:logger, :sweet_xml, :xml_builder],
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
      {:xml_builder, "~> 0.0.8"},
      {:credo, "~> 0.3", only: [:dev, :test]}
    ]
  end
end
