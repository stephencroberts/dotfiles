#!/bin/sh

if [ "$1" = macos ]; then
	brew_install koekeishiya/formulae/yabai
	yabai --start-service
	brew install koekeishiya/formulae/skhd
	skhd --start-service
else
	type yabai >/dev/null || {
		log_error "$1 is not supported!"
		return 0
	}
fi

link_file "$DOTFILES/modules/yabai/.yabairc"
link_file "$DOTFILES/modules/yabai/.skhdrc"
