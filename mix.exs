defmodule Bertex.Mixfile do
  use Mix.Project

  @description """
    Elixir BERT encoder/decoder
  """

  def project do
    [ app: :bertex,
      version: "1.3.0",
      elixir: "~> 1.0",
      name: "Bertex",
      description: @description,
      package: package(),
      deps: [],
      source_url: "https://github.com/edgurgel/bertex" ]
  end

  def application, do: []

  defp package do
    [ maintainers: ["Eduardo Gurgel Pinho"],
      licenses: ["MIT"],
      links: %{ "Github" => "https://github.com/edgurgel/bertex" } ]
  end
end
