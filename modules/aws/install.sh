#!/bin/sh

if [ "$1" = macos ]; then
  brew_install awscli
else
  type awscli >/dev/null || {
    log_error "$1 is not supported!"
  return 0
  }
fi
