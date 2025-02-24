#!/bin/sh

type asdf >/dev/null || {
	log_error "Please install the asdf module!"
	return 0
}

asdf plugin list | grep python >/dev/null || asdf plugin add python
asdf install python latest || true
asdf set -u python latest
