#!/bin/sh

type asdf >/dev/null || {
  log_error "Please install the asdf module!"
  return 0
}

asdf plugin list | grep terraform >/dev/null \
  || asdf plugin-add \
     terraform https://github.com/asdf-community/asdf-hashicorp.git
asdf install terraform latest
asdf global terraform latest
