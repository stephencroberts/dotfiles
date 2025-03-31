#!/bin/sh

type asdf >/dev/null || {
	log_error "Please install the asdf module!"
	return 0
}

if [ "$1" = debian ]; then
	apt_install libbz2-dev
	apt_install libffi-dev
	apt_install liblzma-dev
	apt_install libreadline-dev
	apt_install libsqlite3-dev
	apt_install libssl-dev
	apt_install tk-dev
	apt_install zlib1g-dev
fi

asdf plugin list | grep python >/dev/null || asdf plugin add python
asdf install python latest || true
asdf set -u python latest
