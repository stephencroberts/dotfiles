#!/bin/sh

if [ "$OS_NAME" = debian ]; then
	apt_install libbz2-dev
	apt_install libffi-dev
	apt_install liblzma-dev
	apt_install libreadline-dev
	apt_install libsqlite3-dev
	apt_install libssl-dev
	apt_install tk-dev
	apt_install zlib1g-dev
fi

mise use --global python@latest
mise use --global ruff@latest

brew install pyright
