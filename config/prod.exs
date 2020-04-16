import Config

# Every `nil` value should be replaced by the config.toml in production
# You should have `config/defaults.toml` before deploying or compiling

config :logger, level: :info

config :lbry_comment_notifier, LbryCommentNotifier.Lbry,
  url: nil,
  page_size: nil

config :lbry_comment_notifier, LbryCommentNotifier.Emails,
  from: nil,
  to: nil

config :lbry_comment_notifier, LbryCommentNotifier.Mailer,
  server: nil,
  hostname: nil,
  port: nil,
  username: nil,
  password: nil,
  tls: :if_available,
  allowed_tls_versions: [:tlsv1, :"tlsv1.1", :"tlsv1.2"],
  ssl: false,
  retries: 1,
  no_mx_lookups: false,
  auth: :if_available

config :lbry_comment_notifier, LbryCommentNotifier.Repo, database: nil

config :lbry_comment_notifier, LbryCommentNotifier.Scheduler, debug_logging: true
