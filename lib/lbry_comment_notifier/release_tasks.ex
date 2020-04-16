defmodule LbryCommentNotifier.ReleaseTasks do
  @moduledoc false

  @start_apps [
    :sqlitex,
    :ecto,
    :ecto_sql
  ]

  @repos [LbryCommentNotifier.Repo]

  require Logger

  alias Ecto.Migrator

  def migrate(_argv) do
    start_services()

    run_migrations()

    stop_services()
  end

  defp start_services do
    Logger.info("Starting dependencies..")

    Enum.each(@start_apps, &Application.ensure_all_started/1)

    Logger.info("Starting repos..")

    Enum.each(@repos, & &1.start_link(pool_size: 2))
  end

  defp stop_services do
    Logger.info("Success!")

    :init.stop()
  end

  defp run_migrations do
    Enum.each(@repos, &run_migrations_for/1)
  end

  defp run_migrations_for(repo) do
    app = Keyword.get(repo.config(), :otp_app)

    Logger.info("Running migrations for #{app}")

    migrations_path = priv_path_for(repo, "migrations")

    Migrator.run(repo, migrations_path, :up, all: true)
  end

  defp priv_path_for(repo, filename) do
    app = Keyword.get(repo.config(), :otp_app)

    repo_underscore =
      repo
      |> Module.split()
      |> List.last()
      |> Macro.underscore()

    priv_dir = "#{:code.priv_dir(app)}"

    Path.join([priv_dir, repo_underscore, filename])
  end
end
