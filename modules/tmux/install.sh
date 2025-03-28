#!/bin/sh

if [ "$1" = macos ]; then
	brew_install tmux
elif [ "$1" = alpine ]; then
	apk_add tmux
elif [ "$1" = debian ]; then
	apt_install tmux
else
	type tmux >/dev/null || {
		log_error "$1 is not supported!"
		return 0
	}
fi

link_file "$DOTFILES/modules/tmux/.tmux.conf"

if [ -d "$HOME/.tmux/plugins/tpm/.git" ]; then
	wd=$PWD
	cd "$HOME/.tmux/plugins/tpm" || return
	git pull
	cd "$wd" || return
else
	git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi

"$HOME/.tmux/plugins/tpm/bin/install_plugins"
