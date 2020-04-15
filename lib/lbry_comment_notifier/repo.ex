defmodule LbryCommentNotifier.Repo do
  @moduledoc false

  use Ecto.Repo, otp_app: :lbry_comment_notifier, adapter: Etso.Adapter
end
