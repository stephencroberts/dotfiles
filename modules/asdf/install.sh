if [ "$1" = macos ]; then
  brew list asdf >/dev/null || brew install asdf
elif [ "$1" = alpine ]; then
  [ -e ~/.asdf ] || git clone https://github.com/asdf-vm/asdf.git ~/.asdf
else
  log_error "$1 is not supported!"
  return 0
fi
