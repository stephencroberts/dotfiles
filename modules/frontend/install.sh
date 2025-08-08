#!/bin/sh

if [ "$OS_NAME" = macos ]; then
	brew_install tidy-html5
elif [ "$OS_NAME" = alpine ]; then
	apk_add tidyhtml
else
	type tidy >/dev/null || {
		log_error "$OS_NAME is not supported!"
		return 0
	}
fi
