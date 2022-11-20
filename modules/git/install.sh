#!/bin/sh

if [ "$1" = macos ]; then
  brew_install git
  brew_install gpg
elif [ "$1" = alpine ]; then
  apk_add git
  apk_add gpg
  apk_add gpg-agent

  # Fix agent graph
  # https://github.com/NixOS/nixpkgs/issues/29331
  mkdir $HOME/.gnupg
elif [ "$1" = debian ]; then
  apt_install git
  apt_install gpg
else
  type git >/dev/null || {
    log_error "$1 is not supported!"
    return 0
  }
fi

link_file "$DOTFILES/modules/git/.gitconfig"
