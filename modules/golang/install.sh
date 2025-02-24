#!/bin/sh

type asdf >/dev/null || {
	log_error "Please install the asdf module!"
	return 0
}

asdf plugin list | grep golang >/dev/null ||
	asdf plugin add golang
asdf install golang latest || true
asdf set -u golang latest
