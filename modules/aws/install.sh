#!/bin/sh

type asdf >/dev/null || {
	log_error "Please install the asdf module!"
	return 0
}

asdf plugin list | grep awscli >/dev/null || asdf plugin add awscli
asdf install awscli latest || true
asdf set -u awscli latest

# Enable aws cli integration
if type op >/dev/null; then
	printf -- "Configure 1Password AWS plugin (y/n)? "
	read -r answer
	if [ "$answer" = y ]; then
		op plugin init aws
	fi
fi

if [ "$1" = macos ]; then
	sudo softwareupdate --install-rosetta
	brew_install aws-vpn-client
fi
