defmodule WhisperBot.MixProject do
  use Mix.Project

  def project do
    [
      app: :whisper_bot,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {WhisperBot.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:kino_bumblebee, "~> 0.3.0"},
      {:exla, "~> 0.5.1"},
      {:ex_gram, "~> 0.34.0"},
      {:tesla, "~> 1.2"},
      {:hackney, "~> 1.12"},
      {:jason, ">= 1.0.0"},
      {:logger_file_backend, "0.0.11"}
    ]
  end
end
