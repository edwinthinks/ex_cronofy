defmodule ExCronofy.MixProject do
  use Mix.Project

  def project do
    [
      app: :ex_cronofy,
      version: "0.1.0",
      elixir: "~> 1.10",
      description: description(),
      package: package(),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ],
      source_url: "https://github.com/edwinthinks/ex_cronofy/"
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
      {:httpoison, "~> 1.6"},
      {:poison, "~> 3.1"},
      {:ex_doc, "~> 0.21", only: :dev, runtime: false},
      {:credo, "~> 1.4", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev, :test], runtime: false},
      {:mock, "~> 0.3.0", only: :test},
      {:faker, "~> 0.13", only: :test},
      {:excoveralls, "~> 0.10", only: :test}
    ]
  end

  defp description() do
    "A elixir API client library to utilize Cronofy services to manage calendar events! With this library you can programmatically read and create calendar events."
  end

  defp package() do
    [
      name: "ex_cronofy",
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => "https://github.com/edwinthinks/ex_cronofy/"}
    ]
  end
end
