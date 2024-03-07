# Sets up everything required for Debian
init_debian() {
  log_header "Updating apt"
  $maybe_sudo apt-get -qq update
  $maybe_sudo apt-get -qq dist-upgrade

  # I can't survive without jq
  log_header "Installing essentials"
  $maybe_sudo apt-get -qq install curl
  $maybe_sudo apt-get -qq install jq
  $maybe_sudo apt-get -qq install xclip
}

apt_install() {
  type "$1" >/dev/null || {
    log_header "Installing $1"
    $maybe_sudo apt-get -qq install "$1"
  }
}
