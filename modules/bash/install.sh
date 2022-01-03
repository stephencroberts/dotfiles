if [ "$1" = macos ]; then
  brew list bash >/dev/null || brew install bash
elif [ "$1" = alpine ]; then
  type bash >/dev/null || apk add bash
fi

link_file "$DOTFILES/modules/bash/.bash_profile"
link_file "$DOTFILES/modules/bash/.bashrc"
