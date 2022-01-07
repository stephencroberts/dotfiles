init_alpine() {
  log_header "Updating apk"
  apk update

  log_header "Installing essentials"
  apk_add curl
  apk_add jq
}

apk_add() {
  type "$1" >/dev/null || {
    log_header "Installing $1"
    apk add "$1"
  }
}
