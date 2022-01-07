#########################################
# Sets up everything required for MacOS #
#########################################
init_macos() {
  # Install Homebrew.
  if ! type brew >/dev/null; then
    if [ ! -e /opt/homebrew/bin/brew ]; then
      log_header "Installing Homebrew"
      /bin/bash -c "$(curl --fail --silent --show-error --location \
        https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    eval "$(/opt/homebrew/bin/brew shellenv)"
    brew autoupdate start --upgrade
  fi

  # Exit if, for some reason, Homebrew is not installed.
  type brew >/dev/null || {
    log_error "Homebrew failed to install."
    return 1
  }

  log_header "Updating Homebrew"
  brew doctor || true # Brew is exiting non-zero with just warnings...
  brew update

  # I can't survive without jq
  log_header "Installing essentials"
  brew_install jq
}

brew_install() {
  brew list "$1" >/dev/null || {
    log_header "Installing $1"
    brew install "$1"
  }
}

brew_cask_install() {
  brew list --cask "$1" >/dev/null || {
    log_header "Installing $1"
    brew install --cask "$1"
  }
}
