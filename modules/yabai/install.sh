#!/bin/sh

if [ "$1" = macos ]; then
  brew_install koekeishiya/formulae/yabai
else
  type yabai >/dev/null || {
    log_error "$1 is not supported!"
    return 0
  }
fi
