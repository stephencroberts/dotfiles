#!/bin/sh

if [ "$1" = macos ]; then
  brew_install autossh
fi

mkdir -p "$HOME/.ssh"
link_file "$DOTFILES/modules/ssh/config" "$HOME/.ssh/config"
