if [ "$1" = macos ]; then
  brew_install bash
elif [ "$1" = alpine ]; then
  apk_add bash
elif [ "$1" = debian ]; then
  apt_install bash
else
  type bash >/dev/null || {
    log_error "$1 is not supported!"
    return 0
  }
fi

link_file "$DOTFILES/modules/bash/.bash_profile"
link_file "$DOTFILES/modules/bash/.bashrc"
