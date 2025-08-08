#!/bin/sh

if [ ! -d FiraCodeiScript ]; then
	git clone https://github.com/kencrocken/FiraCodeiScript.git
fi

if [ "$OS_NAME" = macos ]; then
	brew_cask_install font-fira-code
	cp FiraCodeiScript/*.ttf "$HOME/Library/Fonts"
else
	log_error "$OS_NAME is not supported!"
	return 0
fi
