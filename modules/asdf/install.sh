#!/bin/sh

if [ "$1" = macos ]; then
  brew_install asdf
  mkdir -p "${ASDF_DATA_DIR:-$HOME/.asdf}/completions"
  asdf completion zsh > "${ASDF_DATA_DIR:-$HOME/.asdf}/completions/_asdf"
elif [ "$1" = alpine ]; then
  apk_add unzip
  [ -e ~/.asdf ] || git clone https://github.com/asdf-vm/asdf.git ~/.asdf
elif [ "$1" = debian ]; then
  apt_install unzip
  [ -e ~/.asdf ] || git clone https://github.com/asdf-vm/asdf.git ~/.asdf
else
  type unzip >/dev/null || {
    log_error "$1 is not supported!"
    return 0
  }
  [ -e ~/.asdf ] || git clone https://github.com/asdf-vm/asdf.git ~/.asdf
fi
