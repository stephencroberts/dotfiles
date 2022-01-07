if [ "$1" = macos ]; then
  brew_install git
elif [ "$1" = alpine ]; then
  apk_add git
elif [ "$1" = debian ]; then
  apt_install git
else
  log_error "$1 is not supported!"
  return 0
fi

link_file "$DOTFILES/modules/git/.gitconfig"
