defmodule LbryCommentNotifier.Application do
  @moduledoc false

  require Logger

  use Application

  alias LbryCommentNotifier, as: App

  def start(_type, _args) do
    Logger.info("Starting application")

    children = [
      %{
        id: LbryCommentNotifier.Repo.Supervisor,
        start: {LbryCommentNotifier.Repo, :start_link, []}
      },
      App.Scheduler,
      App.Watcher
    ]

    opts = [strategy: :one_for_one, name: LbryCommentNotifier.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
