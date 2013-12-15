defmodule Bertex.Mixfile do
  use Mix.Project

  def project do
    [ app: :bertex,
      version: "1.1.2",
      elixir: "~> 0.11.2",
      deps: deps ]
  end

  def application do
    []
  end

  defp deps do
    []
  end
end
