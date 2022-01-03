if [ "$1" = macos ]; then
  brew list tmux >/dev/null || brew install tmux
elif [ "$1" = alpine ]; then
  type tmux >/dev/null || apk add tmux
elif [ "$1" = ubuntu ]; then
  type tmux >/dev/null || sudo apt-get -qq install tmux
fi

link_file "$DOTFILES/modules/tmux/.tmux.conf"
link_file "$DOTFILES/modules/tmux/.tmuxline.conf"
