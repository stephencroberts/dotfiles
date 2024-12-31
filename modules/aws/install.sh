#!/bin/sh

type asdf >/dev/null || {
  log_error "Please install the asdf module!"
  return 0
}

asdf plugin list | grep awscli >/dev/null || asdf plugin-add awscli
asdf install awscli latest
asdf global awscli latest
