# Sets up everything required for Debian
init_debian() {
  log_header "Updating apt"
  apt-get -qq update
  apt-get -qq dist-upgrade

  # I can't survive without jq
  log_header "Installing essentials"
  apt-get -qq install jq
}

apt_install() {
  type "$1" >/dev/null || {
    log_header "Installing $1"
    apt-get -qq install "$1"
  }
}
