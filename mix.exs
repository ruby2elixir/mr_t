defmodule MrT.Mixfile do
  use Mix.Project

  def project do
    [app: :mr_t,
     version: "0.5.1",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps(),
     description: "Instant code-reloader and test runner for Elixir in one package",
     source_url: "https://github.com/ruby2elixir/mr_t",
     package: package]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [ mod: { MrT, [] },
      applications: [:exfswatch, :logger],
    ]
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
      {:exfswatch, "~> 0.2.1"},
      {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end

  defp package do
    %{
        maintainers: ["Roman Heinrich"],
        licenses: ["MIT License"],
        links: %{"Github" => "https://github.com/ruby2elixir/mr_t"}
     }
  end
end
