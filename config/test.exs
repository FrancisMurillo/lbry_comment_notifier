import Config

config :logger, level: :warn

config :lbry_comment_notifier, LbryCommentNotifier.Emails,
  from: "notifier@lbry.test",
  to: "user@lbry.test"

config :lbry_comment_notifier, LbryCommentNotifier.Lbry,
  url: "http://localhost:5279",
  page_size: 10

config :lbry_comment_notifier, LbryCommentNotifier.Repo, database: "data.test.sqlite3"

config :lbry_comment_notifier, LbryCommentNotifier.Scheduler, debug_logging: false

config :lbry_comment_notifier, LbryCommentNotifier.Watcher, schedule: "@hourly"
