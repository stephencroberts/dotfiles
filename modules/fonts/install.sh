if [ "$1" = macos ]; then
  brew tap | grep homebrew/cask-fonnts >/dev/null \
    || brew tap homebrew/cask-fonts
  brew list --cask font-fira-code >/dev/null \
    || brew install --cask font-fira-code
else
  log_error "$1 is not supported!"
  return 0
fi
