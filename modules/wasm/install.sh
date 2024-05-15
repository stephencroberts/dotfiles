#!/bin/sh

type asdf >/dev/null || {
  log_error "Please install the asdf module!"
  return 0
}

asdf plugin list | grep wasmtime >/dev/null || asdf plugin-add wasmtime
asdf install wasmtime latest
asdf global wasmtime latest
