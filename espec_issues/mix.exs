defmodule EspecIssues.Mixfile do
  use Mix.Project

  def project do
    [
      app: :espec_issues,
      escript: escript_config(),
      version: "0.1.0",
      elixir: "~> 1.3",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps(),
      preferred_cli_env: [
        espec: :test,
        coveralls: :test,
        "coveralls.html": :test
      ],
      test_coverage: [
        tool: ExCoveralls,
        test_task: "espec"
      ],
      # ExDoc stuff
      name: "EspecIssues",
      source_url: "https://www.github.com/mizhi/"
    ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [
      applications: [
        :logger,
        :httpoison,
        :poison
      ]
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
      {:poison,    "~> 3.0"},
      {:httpoison, "~> 0.11"},
      {:earmark,   "~> 1.0", override: true},
      {:espec,     "~> 1.3", only: :test},
      {:excoveralls, "~> 0.6", only: :test},
      {:ex_doc,    "~> 0.14", only: :dev, runtime: false}
    ]
  end

  defp escript_config do
    [ main_module: EspecIssues.CLI ]
  end
end
