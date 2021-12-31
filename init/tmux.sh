if [ "$1" = macos ]; then
  brew list tmux >/dev/null || brew install tmux
elif [ "$1" = ubuntu ]; then
  sudo apt-get -qq install tmux
fi

link_file "$DOTFILES/link/.tmux.conf"
