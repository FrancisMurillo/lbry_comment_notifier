import Config

config :logger, level: :warn

config :lbry_comment_notifier, LbryCommentNotifier.Repo, database: "test.sqlite3"

config :lbry_comment_notifier, LbryCommentNotifier.Scheduler, debug_logging: false
