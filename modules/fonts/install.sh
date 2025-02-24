#!/bin/sh

if [ ! -d FiraCodeiScript ]; then
	git clone https://github.com/kencrocken/FiraCodeiScript.git
fi

if [ "$1" = macos ]; then
	brew_cask_install font-fira-code
	cp FiraCodeiScript/*.ttf $HOME/Library/Fonts
else
	log_error "$1 is not supported!"
	return 0
fi
