#!/bin/sh

type asdf >/dev/null || {
  log_error "Please install the asdf module!"
  return 0
}

asdf plugin list | grep nodejs >/dev/null \
  || asdf plugin-add \
     nodejs https://github.com/asdf-vm/asdf-nodejs.git
asdf install nodejs latest
asdf global nodejs latest
