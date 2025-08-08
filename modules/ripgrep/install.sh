#!/bin/sh

if [ "$OS_NAME" = macos ]; then
	brew_install ripgrep
elif [ "$OS_NAME" = alpine ]; then
	apk_add ripgrep
elif [ "$OS_NAME" = debian ]; then
	if ! type ripgrep >/dev/null; then
		# Try installing with apt with fallback to git
		apt_install ripgrep || {
			curl -LO https://github.com/BurntSushi/ripgrep/releases/download/13.0.0/ripgrep_13.0.0_amd64.deb
			dpkg -i ripgrep_13.0.0_amd64.deb
		}
	fi
else
	type rg >/dev/null || {
		log_error "$OS_NAME is not supported!"
		return 0
	}
fi

link_file "$DOTFILES/modules/ripgrep/.ripgreprc"
