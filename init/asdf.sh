if [ "$1" = macos ]; then
  brew list asdf >/dev/null || brew install asdf
fi
