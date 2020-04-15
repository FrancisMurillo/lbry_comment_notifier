defmodule LbryCommentNotifier.Application do
  @moduledoc false

  use Application

  alias LbryCommentNotifier, as: App

  def start(_type, _args) do
    children = [
      %{
        id: LbryCommentNotifier.Repo.Supervisor,
        start: {LbryCommentNotifier.Repo, :start_link, []}
      },
      App.Scheduler
    ]

    opts = [strategy: :one_for_one, name: LbryCommentNotifier.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
