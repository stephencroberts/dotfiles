#!/bin/sh

if [ "$1" = macos ]; then
	brew_install clang-format
	brew_install cmake
	brew_install gcc
else
	type gcc >/dev/null || {
		log_error "$1 is not supported!"
		return 0
	}
fi
