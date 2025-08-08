#!/bin/sh

if [ "$OS_NAME" = macos ]; then
	brew_install tmux
elif [ "$OS_NAME" = alpine ]; then
	apk_add tmux
elif [ "$OS_NAME" = debian ]; then
	apt_install tmux
else
	type tmux >/dev/null || {
		log_error "$OS_NAME is not supported!"
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
