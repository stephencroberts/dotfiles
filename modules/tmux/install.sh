if [ "$1" = macos ]; then
  brew list tmux >/dev/null || brew install tmux
elif [ "$1" = alpine ]; then
  type tmux >/dev/null || apk add tmux
elif [ "$1" = debian ]; then
  type tmux >/dev/null || apt-get -qq install tmux
else
  log_error "$1 is not supported!"
  return 0
fi

link_file "$DOTFILES/modules/tmux/.tmux.conf"
link_file "$DOTFILES/modules/tmux/.tmuxline.conf"
