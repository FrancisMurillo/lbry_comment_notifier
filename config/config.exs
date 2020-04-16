import Config

config :tesla, adapter: Tesla.Adapter.Hackney

config :lbry_comment_notifier, LbryCommentNotifier.Lbry,
  url: "http://localhost:5279",
  page_size: 10

config :lbry_comment_notifier, ecto_repos: [LbryCommentNotifier.Repo]

config :lbry_comment_notifier, LbryCommentNotifier.Mailer, adapter: Bamboo.SMTPAdapter

config :lbry_comment_notifier, LbryCommentNotifier.Repo, adapter: Sqlite.Ecto2

import_config "#{Mix.env()}.exs"
