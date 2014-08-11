defmodule Bertex.Mixfile do
  use Mix.Project

  def project do
    [ app: :bertex,
      version: "1.2.0",
      elixir: "~> 0.14.2 or ~> 0.15.0",
      deps: [] ]
  end

  def application do
    []
  end
end
