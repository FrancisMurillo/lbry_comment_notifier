import Config

config :logger, level: :info

config :lbry_comment_notifier, LbryCommentNotifier.Repo, database: "data.sqlite3"

config :lbry_comment_notifier, LbryCommentNotifier.Scheduler, debug_logging: false
