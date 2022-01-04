if [ "$1" = macos ]; then
  if ! brew list fzf >/dev/null; then
    brew install fzf
    "$(brew --prefix)/opt/fzf/install"
  fi
elif [ "$1" = alpine ]; then
  type fzf >/dev/null || apk add fzf
else
  log_error "$1 is not supported!"
fi
