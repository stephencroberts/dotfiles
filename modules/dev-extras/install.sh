if [ "$1" = macos ]; then
  brew list jq >/dev/null || brew install jq
elif [ "$1" = alpine ]; then
  type jq >/dev/null || apk add jq
fi
