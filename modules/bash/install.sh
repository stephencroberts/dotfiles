if [ "$1" = macos ]; then
  brew list bash >/dev/null || brew install bash
elif [ "$1" = alpine ]; then
  type bash >/dev/null || apk add bash
elif [ "$1" = debian ]; then
  type bash >/dev/null || apt-get -qq install bash
else
  log_error "$1 is not supported!"
  return 0
fi

link_file "$DOTFILES/modules/bash/.bash_profile"
link_file "$DOTFILES/modules/bash/.bashrc"
