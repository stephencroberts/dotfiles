if [ "$1" = macos ]; then
  brew list git >/dev/null || brew install git
else
  log_error "$1 is not supported!"
fi
link_file "$DOTFILES/modules/git/.gitconfig"
