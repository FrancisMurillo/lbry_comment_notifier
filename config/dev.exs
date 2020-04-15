import Config

config :logger, level: :debug

config :lbry_comment_notifier, LbryCommentNotifier.Emails,
  from: "notifier@lbry.local",
  to: "user@lbry.local"

config :lbry_comment_notifier, LbryCommentNotifier.Repo, database: "data.sqlite3"

config :lbry_comment_notifier, LbryCommentNotifier.Scheduler, debug_logging: true

config :lbry_comment_notifier, LbryCommentNotifier.Mailer,
  server: "localhost",
  hostname: "localhost",
  port: 1025,
  tls: :if_available,
  allowed_tls_versions: [:tlsv1, :"tlsv1.1", :"tlsv1.2"],
  ssl: false,
  retries: 1,
  no_mx_lookups: false,
  auth: :if_available
