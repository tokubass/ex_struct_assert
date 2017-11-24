defmodule StructAssert.Mixfile do
  use Mix.Project

  def project do
    [app: :struct_assert,
     version: "0.5.1",
     elixir: "~> 1.4",
     description: "A useful tool for testing sturct and map in Elixir",
     package: [
       maintainers: ["tokubass"],
       licenses: ["This library is free software"],
       links: %{"GitHub" => "https://github.com/tokubass/ex_struct_assert"}
     ],
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    [extra_applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:my_dep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:my_dep, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:deep_merge, "~> 0.1.1"},
      {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end
end
