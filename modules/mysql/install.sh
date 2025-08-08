#!/bin/sh

if [ "$OS_NAME" = macos ]; then
	brew_install mysql-client
	brew_install mysqlworkbench
else
	type git >/dev/null || {
		log_error "$OS_NAME is not supported!"
		return 0
	}
fi
