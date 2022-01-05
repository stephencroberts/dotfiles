if [ "$1" = macos ]; then
  brew list ripgrep >/dev/null || brew install ripgrep
elif [ "$1" = alpine ]; then
  type ripgrep >/dev/null || apk add ripgrep
else
  log_error "$1 is not supported!"
  return 0
fi
