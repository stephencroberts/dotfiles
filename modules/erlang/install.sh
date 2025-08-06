#!/bin/sh

if [ "$1" = alpine ]; then
	# Required to build erlang
	apk_add build-base
	apk_add ncurses-dev
	apk_add openssl-dev
	apk_add perl
	apk_add unixodbc-dev
fi

mise use --global erlang@latest
mise use --global rebar@latest

# Hack to fix issue with terminal output being garbled after using rebar3
# https://github.com/erlang/rebar3/issues/2472#issuecomment-762270455
mise exec rebar@latest -- rebar3 local install
mise exec rebar@latest -- rebar3 local upgrade

link_file "$DOTFILES/modules/erlang/rebar.config" \
	"$HOME/.config/rebar3/rebar.config"
