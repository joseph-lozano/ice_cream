defmodule IceCream.MixProject do
  use Mix.Project

  def project do
    [
      name: "Ice Cream",
      app: :ice_cream,
      version: "0.0.2",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: "Never use IO.inspect again",
      source_url: "https://github.com/joseph-lozano/ice_cream",
      package: package(),
      docs: [
        main: "readme",
        logo: "logo.svg",
        extras: ["README.md"]
      ]
    ]
  end

  defp package() do
    [
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/joseph-lozano/ice_cream"}
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    []
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end
end
