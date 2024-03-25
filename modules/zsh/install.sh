#!/bin/sh

if [ "$1" = macos ]; then
  brew_install zsh
  brew_install zoxide
elif [ "$1" = alpine ]; then
  apk_add zsh
elif [ "$1" = debian ]; then
  apt_install zsh
  type zoxide >/dev/null || {
    curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
    $maybe_sudo mv "$HOME/.local/bin/zoxide" /usr/local/bin
  }
else
  type zsh >/dev/null || {
    log_error "$1 is not supported!"
    return 0
  }
fi

if [ ! -e "${ZDOTDIR:-$HOME}/.zprezto" ]; then
  git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"

  # Symlink defaults
  for rcfile in $(ls "${ZDOTDIR:-$HOME}"/.zprezto/runcoms | grep -v README.md)
  do
    ln -sf "${ZDOTDIR:-$HOME}/.zprezto/runcoms/$rcfile" \
      "${ZDOTDIR:-$HOME}/.$rcfile"
  done
fi

# Symlink overrides
link_file "$DOTFILES/modules/zsh/.zpreztorc"
link_file "$DOTFILES/modules/zsh/.zprofile"
link_file "$DOTFILES/modules/zsh/.zshrc"
