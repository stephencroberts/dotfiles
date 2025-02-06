#!/bin/sh

type asdf >/dev/null || {
  log_error "Please install the asdf module!"
  return 0
}

asdf plugin list | grep dotnet >/dev/null || asdf plugin add dotnet
asdf install dotnet latest || true
asdf set -u dotnet latest
