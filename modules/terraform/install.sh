#!/bin/sh

type asdf >/dev/null || {
	log_error "Please install the asdf module!"
	return 0
}

if [ "$1" = alpine ]; then
	apk_add gpg
	apk_add gpg-agent
fi

asdf plugin list | grep terraform >/dev/null ||
	asdf plugin add \
		terraform https://github.com/asdf-community/asdf-hashicorp.git
asdf install terraform latest || true
asdf set -u terraform latest
