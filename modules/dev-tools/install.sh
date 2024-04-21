#!/bin/sh

type asdf >/dev/null || {
  log_error "Please install the asdf module!"
  return 0
}

asdf plugin list | grep just >/dev/null || asdf plugin-add just
asdf install just latest
asdf global just latest
