#!/bin/sh

if [ "$OS_NAME" = alpine ]; then
	apk_add gpg
	apk_add gpg-agent
fi

mise use --global terraform@latest
