#!/bin/sh

if [ "$1" = macos ]; then
  brew_install mysql-client
  brew_install mysqlworkbench
else
  type git >/dev/null || {
    log_error "$1 is not supported!"
    return 0
  }
fi
