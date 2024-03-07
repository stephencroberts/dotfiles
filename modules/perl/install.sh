#!/bin/sh

type asdf >/dev/null || {
  log_error "Please install the asdf module!"
  return 0
}

asdf plugin list | grep perl >/dev/null \
  || asdf plugin-add perl
asdf install perl latest
asdf global perl latest
