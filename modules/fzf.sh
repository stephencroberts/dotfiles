if [ "$1" = macos ]; then
  if ! brew list fzf >/dev/null; then
    brew install fzf
    "$(brew --prefix)/opt/fzf/install"
  fi
fi
