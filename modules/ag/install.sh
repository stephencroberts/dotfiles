if [ "$1" = macos ]; then
  brew list the_silver_searcher >/dev/null || brew install the_silver_searcher
fi
