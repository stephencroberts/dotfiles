#!/bin/sh

if [ "$1" = alpine ]; then
	apk_add gpg
	apk_add gpg-agent
fi

mise use --global terraform@latest
