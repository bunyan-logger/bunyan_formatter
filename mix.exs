defmodule BunyanFormatter.MixProject do
  use Mix.Project

  def project do
    [
      app:     :bunyan_formatter,
      version: "0.1.0",
      elixir:  "~> 1.6",
      deps:    deps()
    ]
  end

  def application, do: []

  defp deps do
    [
      { :bunyan_shared, path: "../bunyan_shared" },
    ]
  end
end
