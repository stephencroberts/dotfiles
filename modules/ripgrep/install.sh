if [ "$1" = macos ]; then
  brew list ripgrep >/dev/null || brew install ripgrep
fi
