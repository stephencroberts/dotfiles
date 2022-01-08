if [ "$1" = macos ]; then
  brew_install tmux
elif [ "$1" = alpine ]; then
  apk_add tmux
elif [ "$1" = debian ]; then
  apt_install tmux
else
  type tmux >/dev/null || {
    log_error "$1 is not supported!"
    return 0
  }
fi

link_file "$DOTFILES/modules/tmux/.tmux.conf"
link_file "$DOTFILES/modules/tmux/.tmuxline.conf"
