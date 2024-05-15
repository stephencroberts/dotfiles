#!/bin/sh

type asdf >/dev/null || {
  log_error "Please install the asdf module!"
  return 0
}

asdf plugin list | grep wasmtime >/dev/null || asdf plugin-add wasmtime
asdf install wasmtime v20.0.2
asdf global wasmtime v20.0.2
