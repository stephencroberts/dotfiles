#!/bin/sh

if [ "$1" = macos ]; then
  brew_install awscli
elif [ "$1" = alpine ]; then
  apk_add aws-cli
else
  type awscli >/dev/null || {
    log_error "$1 is not supported!"
  return 0
  }
fi
