#!/bin/sh

if [ "$1" = macos ]; then
  brew_install tidy-html5
else
  type tidy >/dev/null || {
    log_error "$1 is not supported!"
    return 0
  }
fi
