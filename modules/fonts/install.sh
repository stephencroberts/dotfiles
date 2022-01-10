#!/bin/sh

if [ "$1" = macos ]; then
  brew tap | grep homebrew/cask-fonnts >/dev/null \
    || brew tap homebrew/cask-fonts
  brew_cask_install font-fira-code
else
  log_error "$1 is not supported!"
  return 0
fi
