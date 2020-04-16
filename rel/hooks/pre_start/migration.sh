#!/bin/sh

release_ctl eval --mfa "LbryCommentNotifier.ReleaseTasks.migrate/1" --argv -- "$@"
