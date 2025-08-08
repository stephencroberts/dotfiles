#!/bin/sh

if [ "$OS_NAME" = macos ]; then
	brew_install shellcheck
	brew_install shfmt
elif [ "$OS_NAME" = debian ]; then
	snap_install shellcheck
	snap_install shfmt
else
	if ! type shellcheck >/dev/null || ! type shfmt >/dev/null; then
		log_error "$OS_NAME is not supported!"
		return 0
	fi
fi
