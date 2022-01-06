if [ "$1" = macos ]; then
  brew list jq >/dev/null || brew install jq
elif [ "$1" = alpine ]; then
  type jq >/dev/null || apk add jq
elif [ "$1" = debian ]; then
  type jq >/dev/null || apt-get -qq install jq
else
  log_error "$1 is not supported!"
  return 0
fi
