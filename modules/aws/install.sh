#!/bin/sh

mise use --global awscli@latest

# Enable aws cli integration
if type op >/dev/null; then
	printf -- "Configure 1Password AWS plugin (y/n)? "
	read -r answer
	if [ "$answer" = y ]; then
		op plugin init aws
	fi
fi

if [ "$OS_NAME" = macos ]; then
	sudo softwareupdate --install-rosetta
	brew_install aws-vpn-client
fi
