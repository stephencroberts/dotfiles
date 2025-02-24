#!/bin/sh

if [ "$1" = macos ]; then
	brew_install tidy-html5
elif [ "$1" = alpine ]; then
	apk_add tidyhtml
else
	type tidy >/dev/null || {
		log_error "$1 is not supported!"
		return 0
	}
fi
