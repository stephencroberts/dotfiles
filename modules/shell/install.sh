#!/bin/sh

if [ "$1" = macos ]; then
	brew_install shellcheck
	brew_install shfmt
elif [ "$1" = debian ]; then
	snap_install shellcheck
	snap_install shfmt
else
	if ! type shellcheck >/dev/null || ! type shfmt >/dev/null; then
		log_error "$1 is not supported!"
		return 0
	fi
fi
