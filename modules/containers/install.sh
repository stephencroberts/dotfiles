#!/bin/sh

if [ "$1" = macos ]; then
  brew_install colima
  brew_install docker
else
  type colima >/dev/null || {
    log_error "$1 is not supported!"
    return 0
  }
fi
