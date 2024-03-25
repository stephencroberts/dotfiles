#!/bin/sh

type asdf >/dev/null || {
  log_error "Please install the asdf module!"
  return 0
}

asdf plugin list | grep rust >/dev/null || asdf plugin-add rust
asdf install rust latest
asdf global rust latest
