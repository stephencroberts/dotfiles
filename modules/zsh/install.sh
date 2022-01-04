if [ "$1" = macos ]; then
  brew list zsh >/dev/null || brew install zsh
elif [ "$1" = alpine ]; then
  type zsh >/dev/null || apk add zsh
else
  log_error "$1 is not supported!"
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
