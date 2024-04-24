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

  # Enable touch/watch id for sudo
  # https://sixcolors.com/post/2023/08/in-macos-sonoma-touch-id-for-sudo-can-survive-updates/
  # https://andre.arko.net/2020/07/10/sudo-with-touchid-and-apple-watch-even-inside-tmux/
  if [ ! -e "/etc/pam.d/sudo_local" ]; then
    cat >sudo_local <<EOF
auth       optional       /opt/homebrew/lib/pam/pam_reattach.so
auth       sufficient     pam_watchid.so     "reason=execute a command as root"
auth       sufficient     pam_tid.so
EOF
    sudo mv sudo_local /etc/pam.d/sudo_local
  fi

  sudo mkdir -p /usr/local/lib/pam
  if [ ! -e /usr/local/lib/pam/pam_watchid.so ]; then
    sudo cp "$DOTFILES/lib/pam_watchid.so" /usr/local/lib/pam/pam_watchid.so
  fi

  brew_install pam-reattach
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
