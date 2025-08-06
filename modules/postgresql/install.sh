#!/bin/sh

if [ "$1" = macos ]; then
	brew_install gcc
	brew_install icu4c
	brew_install ossp-uuid
	brew_install pkg-config
	brew_install readline
	brew_install zlib
fi

mise use --global postgres@latest
