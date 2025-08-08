#!/bin/sh

if [ "$OS_NAME" = macos ]; then
	if ! brew list fzf >/dev/null; then
		brew_install fzf
		"$(brew --prefix)/opt/fzf/install"
	fi
elif [ "$OS_NAME" = alpine ]; then
	apk_add fzf
elif [ "$OS_NAME" = debian ]; then
	if ! type fzf >/dev/null; then
		# Try installing with apt with fallback to git
		apt_install fzf || {
			[ -d "$HOME/.fzf" ] ||
				git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
			"$HOME/.fzf/install"
		}
	fi
else
	type fzf >/dev/null || {
		log_error "$OS_NAME is not supported!"
		return 0
	}
fi
