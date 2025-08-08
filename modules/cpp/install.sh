#!/bin/sh

if [ "$OS_NAME" = macos ]; then
	brew_install clang-format
	brew_install cmake
	brew_install gcc
else
	type gcc >/dev/null || {
		log_error "$OS_NAME is not supported!"
		return 0
	}
fi
