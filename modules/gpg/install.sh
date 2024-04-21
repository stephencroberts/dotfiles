#!/bin/sh

if [ "$1" = macos ]; then
  brew_install gnupg
  brew_install pinentry-mac
  link_file "$DOTFILES/modules/gpg/gpg-agent.conf" \
    "$HOME/.gnupg/gpg-agent.conf"
elif [ "$1" = alpine ]; then
  apk_add gpg
  apk_add gpg-agent

  # Fix agent graph
  # https://github.com/NixOS/nixpkgs/issues/29331
  mkdir $HOME/.gnupg
elif [ "$1" = debian ]; then
  apt_install gpg
  link_file "$DOTFILES/modules/gpg/gpg-agent.debian.conf" \
    "$HOME/.gnupg/gpg-agent.conf"
else
  type gpg >/dev/null || {
    log_error "$1 is not supported!"
    return 0
  }
fi

link_file "$DOTFILES/modules/gpg/gpg.conf" "$HOME/.gnupg/gpg.conf"
chmod 700 "$HOME/.gnupg"

if [ "$(gpg --list-secret-keys | wc -l | xargs)" = 0 ]; then
  printf -- "Import GPG key from 1Password (y/n)? "
  read -r answer
  if [ "$answer" = y ]; then
    printf -- "Vault: "
    read -r vault
    printf -- "Secret: "
    read -r secret
    printf -- "File: "
    read -r file
    op read "op://$vault/$secret/$file" | gpg --import
  fi
fi

if [ -z "$(cat "$HOME/.gnupg/sshcontrol" | grep -v "#" | xargs)" ]; then
  printf -- "SSH keygrip: "
  read -r keyid
  echo "$keyid" >>"$HOME/.gnupg/sshcontrol"
fi
