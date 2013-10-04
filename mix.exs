defmodule Sparkler.Mixfile do
  use Mix.Project

  def project do
    [ app: :sparkler,
      version: "0.0.1",
      dynamos: [Sparkler.Dynamo],
      compilers: [:elixir, :dynamo, :app],
      env: [prod: [compile_path: "ebin"]],
      compile_path: "tmp/#{Mix.env}/sparkler/ebin",
      deps: deps ]
  end

  # Configuration for the OTP application
  def application do
    [ applications: [:cowboy, :dynamo],
      mod: { Sparkler, [] } ]
  end

  defp deps do
    [ { :cowboy, github: "extend/cowboy" },
      { :dynamo, github: "elixir-lang/dynamo" },
      { :mongoex, "0.0.1", github: "Tonkpils/mongoex" },
      { :json, github: "cblage/elixir-json" }
    ]
  end
end
