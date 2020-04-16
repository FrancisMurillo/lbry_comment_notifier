import Config

config :logger, level: :warn

config :lbry_comment_notifier, LbryCommentNotifier.Repo, database: "data.test.sqlite3"

config :lbry_comment_notifier, LbryCommentNotifier.Scheduler, debug_logging: false

config :lbry_comment_notifier, LbryCommentNotifier.Watcher, schedule: "@hourly"
