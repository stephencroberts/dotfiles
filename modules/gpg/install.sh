#!/bin/sh

if [ "$OS_NAME" = macos ]; then
	brew_install gnupg
	brew_install pinentry-mac
	link_file "$DOTFILES/modules/gpg/gpg-agent.conf" \
		"$HOME/.gnupg/gpg-agent.conf"
elif [ "$OS_NAME" = alpine ]; then
	apk_add gpg
	apk_add gpg-agent

	# Fix agent graph
	# https://github.com/NixOS/nixpkgs/issues/29331
	mkdir -p "$HOME/.gnupg"
elif [ "$OS_NAME" = debian ]; then
	apt_install gpg
	link_file "$DOTFILES/modules/gpg/gpg-agent.debian.conf" \
		"$HOME/.gnupg/gpg-agent.conf"
else
	type gpg >/dev/null || {
		log_error "$OS_NAME is not supported!"
		return 0
	}
fi

link_file "$DOTFILES/modules/gpg/gpg.conf" "$HOME/.gnupg/gpg.conf"

if [ "$(gpg --list-secret-keys | wc -l | xargs)" = 0 ]; then
	printf -- "Import GPG key from 1Password (y/n)? "
	read -r answer
	if [ "$answer" = y ]; then
		printf -- "Account: "
		read -r account
		printf -- "Vault: "
		read -r vault
		printf -- "Secret: "
		read -r secret
		printf -- "File: "
		read -r file
		op --account "$account" read "op://$vault/$secret/$file" | gpg --import
	fi

	gpg -K --with-keygrip

	printf -- "If you would like to setup ssh, enter the keygrip: "
	read -r keygrip
	if [ -n "$keygrip" ]; then
		gpg-connect-agent "keyattr $keygrip Use-for-ssh: true" /bye
	fi
fi

chmod 700 "$HOME/.gnupg"
chmod 600 "$HOME/.gnupg"/*

# (Re)Start the agent
if type gpg-agent >/dev/null && type gpgconf >/dev/null; then
	GPG_TTY=$(tty)
	export GPG_TTY
	gpgconf --kill gpg-agent
	gpgconf --launch gpg-agent
fi
