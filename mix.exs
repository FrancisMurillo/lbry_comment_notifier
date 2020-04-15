defmodule LbryCommentNotifier.MixProject do
  use Mix.Project

  def project do
    [
      app: :lbry_comment_notifier,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {LbryCommentNotifier.Application, []}
    ]
  end

  defp deps do
    [
      {:tesla, "~> 1.3.0"},
      {:hackney, "~> 1.15.2"},
      {:jason, "~> 1.2.0"},
      {:ecto_sql, "~> 3.4.2"},
      {:etso, "~> 0.1.1"}
    ]
  end
end
