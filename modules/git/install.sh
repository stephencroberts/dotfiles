if [ "$1" = macos ]; then
  brew list git >/dev/null || brew install git
elif [ "$1" = alpine ]; then
  type git >/dev/null || apk add git
else
  log_error "$1 is not supported!"
  return 0
fi

link_file "$DOTFILES/modules/git/.gitconfig"
