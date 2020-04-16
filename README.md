# LBRY Comment Notifier

A small Elixir app polling the LBRY API for new comments via email.

Every hour, the application fetches all comments by going throught these
three API methods:
[account_list](https://lbry.tech/api/sdk#account_list),
[claim_list](https://lbry.tech/api/sdk#claim_list) and
[comment_list](https://lbry.tech/api/sdk#comment_list). By fetching all
accounts, the claims can be obtained; using those in turn, the comments
can be fetched. Each comment is stored in the persistent storage and new
comment are emailed. Since the APIs are paginated, the algorithm may not
be the most efficient and perhaps LBRY can offer this functionality at a
lower cost. For now though, paginated polling is good enough for a small
channel.

## Installation

This app was meant to run locally on a Raspberry Pi 3 with a [configured
lbry-sdk as the API](https://github.com/lbryio/lbry-sdk) (or a
[lbry-desktop which hosts an API
too](https://github.com/lbryio/lbry-desktop)) and a [mailcatcher as a
SMTP server](https://github.com/sj26/mailcatcher). So assuming the
default configuration with an `lbry-sdk` running at
`http://localhost:5279` and a `mailcatcher` at `http://0.0.0.0:1080` and
`smtp://0.0.0.0:1025`, the app can be built annd run using:

```shell
mix deps.get

mix run --no-halt

MIX_ENV=prod mix distillery.release

cd _build/prod/rel/lbry_comment_notifier
nano config.toml                            # Check the configuration
bin/lbry_comment_notifier reload_config     # Update the configuration
bin/lbry_comment_notifier foreground
```

It uses the standard
(distillery)[https://github.com/bitwalker/distillery] and
(TOML)[https://github.com/bitwalker/toml-elixir] tooling so you can
checkout `config.toml` in the release directory for the possible
configurations.

## Ideas

To make the application more palatable, the following ideas could be implemented:

[ ] Better email templates
[ ] Switch persistent storage to ETS or Mnesia
