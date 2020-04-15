import Config

config :tesla, adapter: Tesla.Adapter.Hackney

config :lbry_comment_notifier, LbryCommentNotifier.Lbry,
  url: "http://localhost:5279",
  page_size: 10

import_config "#{Mix.env()}.exs"
