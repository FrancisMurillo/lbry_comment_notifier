defmodule LbryCommentNotifier.Emails do
  @moduledoc false

  import Bamboo.Email

  alias Timex

  alias LbryCommentNotifier.{Comment, Repo}

  def new_comment_email(%Comment{} = comment) do
    %{
      comment: body,
      claim: %{name: claim_name},
      commenter_name: commenter_name,
      commenter_url: commenter_url,
      published_at: published_at
    } = Repo.preload(comment, :claim)

    new_email(
      to: to(),
      from: from(),
      subject: "New Comment from #{commenter_name} on #{claim_name}",
      text_body: """
      #{claim_name}
      ---

      #{commenter_name} (#{commenter_url})
      #{Timex.format!(published_at, "%FT %T", :strftime)}
      ===

      #{body}
      """
    )
  end

  defp to(),
    do: config()[:to] || "user@lbry.local"

  defp from(),
    do: config()[:from] || "notifier@lbry.local"

  defp config(),
    do: Application.get_env(:lbry_comment_notifier, __MODULE__) || []
end
