defmodule Tesla.StatsD.Mixfile do
  use Mix.Project

  def project do
    [
      app: :tesla_statsd,
      version: "0.1.1",
      elixir: "~> 1.4",
      start_permanent: Mix.env() == :prod,
      build_embedded: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      description: description(),
      docs: [
        extras: ["README.md"],
        main: "readme"
      ]
    ]
  end

  def description do
    ~S"""
    StatsD instrumenting middleware for Tesla HTTP client
    """
  end

  def package do
    [
      maintainers: ["SaleMove TechMovers"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/salemove/tesla_statsd"}
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
      {:tesla, "~> 1.0"},
      {:mox, "~> 0.3.1", only: :test},
      {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end
end
