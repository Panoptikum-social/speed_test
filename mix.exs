defmodule SpeedTest.MixProject do
  use Mix.Project

  def project do
    [
      app: :speed_test,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [ applications: [:httpoison, :quinn],
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:httpoison, "~> 1.2.0"}, # http client
      # {:hackney, "1.12.1"} # http client
      # {:sweet_xml, "~> 0.6"} # XML parse
      {:quinn, "~> 1.1.2"}, # XML parser
    ]
  end
end
