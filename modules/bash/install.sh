#!/bin/sh

if [ "$OS_NAME" = macos ]; then
	brew_install bash
elif [ "$OS_NAME" = alpine ]; then
	apk_add bash
elif [ "$OS_NAME" = debian ]; then
	apt_install bash
else
	type bash >/dev/null || {
		log_error "$OS_NAME is not supported!"
		return 0
	}
fi

link_file "$DOTFILES/modules/bash/.bash_profile"
link_file "$DOTFILES/modules/bash/.bashrc"
