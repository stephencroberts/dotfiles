#!/bin/sh

type asdf >/dev/null || {
  log_error "Please install the asdf module!"
  return 0
}

if [ "$1" = alpine ]; then
  # Required to build erlang
  apk_add build-base
  apk_add ncurses-dev
  apk_add openssl-dev
  apk_add perl
  apk_add unixodbc-dev
fi

asdf plugin list | grep erlang >/dev/null \
  || asdf plugin add erlang
asdf install erlang latest
asdf global erlang latest

asdf plugin list | grep rebar >/dev/null \
  || asdf plugin add rebar
asdf install rebar latest
asdf global rebar latest

# Hack to fix issue with terminal output being garbled after using rebar3
# https://github.com/erlang/rebar3/issues/2472#issuecomment-762270455
rebar3 local install
rebar3 local upgrade

link_file "$DOTFILES/modules/erlang/rebar.config" \
  "$HOME/.config/rebar3/rebar.config"
