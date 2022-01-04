if [ "$1" = macos ]; then
  brew list ripgrep >/dev/null || brew install ripgrep
else
  log_error "$1 is not supported!"
fi
