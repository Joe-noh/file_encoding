defmodule FileEncoding.Mixfile do
  use Mix.Project

  def project do
    [app: :file_encoding,
     version: "0.0.3",
     elixir: "~> 1.0.0",
     deps: deps]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    []
  end
end
