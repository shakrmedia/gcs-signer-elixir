defmodule GcsSigner.Mixfile do
  use Mix.Project

  def project do
    [
      app: :gcs_signer,
      description: "Simple signed URL generator for Google Cloud Storage",
      package: package(),
      version: "0.2.1",
      elixir: "~> 1.5",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      dialyzer: [
        plt_add_deps: :transitive,
        plt_add_apps: [:mix, :public_key],
        flags: [:race_conditions, :no_opaque]
      ]
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
      {:ex_doc, ">= 0.0.0", only: :dev},
      {:credo, "~> 0.9", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 0.5", only: [:dev, :test], runtime: false},
      {:jason, "~> 1.1", only: [:test]}
    ]
  end

  defp package do
    [
      maintainers: ["Minku Lee"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/shakrmedia/gcs-signer-elixir"}
    ]
  end
end
