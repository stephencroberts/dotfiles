if [ "$1" = macos ]; then
  brew list asdf >/dev/null || brew install asdf
else
  log_error "$1 is not supported!"
fi
