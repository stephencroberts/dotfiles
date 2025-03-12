#!/bin/sh

if [ "$1" = macos ]; then
	brew_install postgresql@17
	brew_install pgadmin4
fi
