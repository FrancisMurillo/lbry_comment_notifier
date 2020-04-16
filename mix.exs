defmodule LbryCommentNotifier.MixProject do
  use Mix.Project

  def project do
    [
      app: :lbry_comment_notifier,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases()
    ]
  end

  def application do
    [
      extra_applications: [:logger, :toml],
      mod: {LbryCommentNotifier.Application, []}
    ]
  end

  defp deps do
    [
      {:tesla, "~> 1.3.0"},
      {:hackney, "~> 1.15.2"},
      {:jason, "~> 1.2.0", override: true},
      {:ecto, "~> 2.2.0"},
      {:sqlite_ecto2, "~> 2.2.0"},
      {:flow, "~> 1.0.0"},
      {:bamboo, "~> 1.4.0"},
      {:bamboo_smtp, "~> 2.1.0"},
      {:timex, "~> 3.6.1"},
      {:quantum, "~> 3.0.0-rc.3"},
      {:distillery, "~> 2.1.1"},
      {:toml, "~> 0.5.2"}
    ]
  end

  defp aliases() do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate"],
      "ecto.reset": ["ecto.drop", "ecto.setup"]
    ]
  end
end
