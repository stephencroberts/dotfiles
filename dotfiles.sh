#!/usr/bin/env sh
#
# My dotfiles install script
#
# ༼ つ ◕_◕ ༽つMUST. HAVE. DOTFILES.༼ つ ◕_◕ ༽つ
#
# Author: Stephen Roberts <stephenroberts@gmail.com>
#
# Usage: dotfiles [--help|-h]
#
#   See the README for documentation.
#   https://github.com/stephencroberts/dotfiles
#
#   Copyright (c) 2015 Stephen Roberts
#   Licensed under the MIT license.g

: "${REPO:=git://github.com/stephencroberts/dotfiles.git}"
: "${DOTFILES:=$HOME/.dotfiles}"
: "${CACHE_FILE:=$DOTFILES/.selected}"
: "${BACKUPS:=$DOTFILES/backups/$(date +%s)}"

# Prints usage to the screen, scraped from the documentation in the script
# header
usage() {
  sed -n "/^# Usage/,/^[^#]/p" "$0" | sed 's/^# \{0,1\}//g' | sed '$d'
}

#
# Logging
#

log_header()   { printf -- '\n\033[1m%b\033[0m\n' "$@"; }
log_success()  { printf -- ' \033[1;32m✔\033[0m  %b\n' "$@"; }
log_error()    { printf -- ' \033[1;31m✖\033[0m  %b\n' "$@" >&2; }
log_arrow()    { printf -- ' \033[1;34m➜\033[0m  %b\n' "$@"; }

# Gets the current OS
#
# Returns: the OS
get_os() {
  if [ "$(uname)" = Darwin ]; then
    echo macos
  elif grep 'Ubuntu' >/dev/null 2>&1 </etc/issue; then
    echo ubuntu
  elif [ -e /etc/alpine-release ]; then
    echo alpine
  else
    log_error "OS not supported!"
    return 1
  fi
}

# Installs git in the target OS
#
# Arguments:
#   - os name
install_git() {
  type -p git >/dev/null 2>&1 && git --version >/dev/null || {
    log_header "Installing git"
    "install_git_$1"
  }

  # Check that git is installed
  type -p git >/dev/null 2>&1 && git --version >/dev/null
}

# git is already installed on MacOS
install_git_macos() {
  printf -- "Waiting for git to be installed. Press ENTER to continue."
  read -r
}

# Installs git for ubuntu
install_git_ubuntu() {
  sudo apt-get -qq install git-core
}

install_git_alpine() {
  apk add --update git
}

#
# Dotfiles administrative things
#

# Download or update dotfiles
#
# Returns: code 1 if dotfiles were updated
fetch_dotfiles() {
  if [ ! -d "$DOTFILES" ]; then
    log_header "Downloading dotfiles"
    git clone "$REPO" "$DOTFILES"
  else
    log_header "Updating dotfiles"
    cd "$DOTFILES"
    prev_head="$(git rev-parse HEAD)"
    git pull
    [ "$(git rev-parse HEAD)" = "$prev_head" ]
  fi
}

# Features menu

# Prints an option as selected
#
# Arguments:
#   - option
prompt_print_selected() {
  printf -- ' \033[1;32m✔\033[0m  %b\n' "$@"
}

# Prints an option as deselected
#
# Arguments:
#   - option
prompt_print_deselected() {
  printf -- ' \033[1;31m✖\033[0m  %b\n' "$@"
}

# Prints a menu with selected/deselected options
#
# Arguments:
#   - heading
#   - all options
#   - selected options
prompt_print_menu() {
  log_header "$1"

  i=1
  for option in $2; do
    if echo "$3" | grep "$option" >/dev/null; then
      prompt_print_selected "$i) $option"
    else
      prompt_print_deselected "$i) $option"
    fi
    i=$((i+1))
  done
}

# Gets an item by index (1-indexed) from a space-delimited list
#
# Arguments:
#   - list
#   - index
#
# Returns: the item at index
get_item_at_index() {
  i=1
  for item in $1; do
    if [ $i -eq "$2" ]; then
      echo "$item"
      break
    fi
    i=$((i+1))
  done
}

# Prompts the user for selections from a menu
#
# This function is recursive, printing the current menu as the user updates
# selections until the user no longer makes new selections. The list of selected
# options is returned in a named variable.
#
# Arguments:
#   - heading
#   - all menu options
#   - selected menu options
#   - wait time (s) for the user to interact with the menu (optional)
#
# Returns: the selected menu options in the variable `prompt_selections`
prompt_menu() {
  heading=$1
  options=$2
  selected=$3
  wait=$4

  prompt_print_menu "$heading" "$options" "$selected"

  if [ -n "$wait" ]; then
    read -rt "$wait" -n 1 \
      -sp "To edit this list, press any key within $wait seconds." || {
      # Return final results
      export prompt_selections=$selected
      return 0
    }
  fi

  # Continue asking the user for changes to the selections until they no longer
  # enter input
  printf -- '\r\033[K'
  if read -rp \
    "Toggle options (Separate options with spaces, ENTER when done): " nums \
    && [ -n "$(echo "$nums" | xargs)" ]; then

    for num in $nums; do

      # Get the menu option at the index the user selected
      option=$(get_item_at_index "$options" "$num")

      # Select/deselect the option
      if echo "$selected" | grep "$option" >/dev/null; then
        selected=${selected//$option/}
      else
        selected="$selected$option "
      fi
    done

    # Recursive! Prompt the user for more changes.
    prompt_menu "$heading" "$options" "$selected"
  fi

  # Return final results
  export prompt_selections=$selected
}

# Executes install scripts as selected by the user
#
# Arguments:
#   - operating system
install_things() {
  menu_options=$(find "$DOTFILES/modules" -maxdepth 1 -not -type d \
    -exec basename {} \; | xargs)

  if [ -f "$CACHE_FILE" ]; then
    menu_selects="$(xargs <"$CACHE_FILE") "
  fi

  prompt_menu 'Suh dude. Wanna install some stuff? ¯\\\_(ツ)\_/¯' \
    "$menu_options" "$menu_selects" 5

  # Write out cache file for future reading.
  echo "$prompt_selections" >"$CACHE_FILE"

  for option in $prompt_selections; do
    log_header "Installing ${option%.sh}"
    . "$DOTFILES/modules/$option" "$1" "$2"
  done
}

# Backs up a file to the backups folder
backup_file() {
  # Create backup dir if it doesn't already exist.
  [ -e "$BACKUPS" ] || mkdir -p "$BACKUPS"
  mv "$1" "$BACKUPS"
}

# Symlinks a file to HOME directory
#
# Arguments:
#   - file
link_file() {
  base=$(basename "$1")
  dst="$HOME/$base"

  if [ -e "$dst" ]; then
    if [ "$1" -ef "$dst" ]; then
      log_error "Skipping ~/$base, same file."
      return 0
    fi

    log_arrow "Backing up ~/$base."
    backup_file "$dst"
  fi

  log_success "Linking ~/$base."
  ln -sf "${1#$HOME/}" ~/
}

# Sets up everything required for MacOS
init_macos() {
  # Install Homebrew.
  if ! type -p brew >/dev/null; then
    if [ ! -e /opt/homebrew/bin/brew ]; then
      log_header "Installing Homebrew"
      /bin/bash -c "$(curl --fail --silent --show-error --location \
        https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi

  # Exit if, for some reason, Homebrew is not installed.
  type -p brew >/dev/null || {
    log_error "Homebrew failed to install."
    return 1
  }

  log_header "Updating Homebrew"
  brew doctor || true # Brew is exiting non-zero with just warnings...
  brew update
}

# Sets up everything required for Ubuntu
init_ubuntu() {
  log_header "Updating apt"
  sudo apt-get -qq update
  sudo apt-get -qq dist-upgrade
}

init_alpine() {
  log_header "Updating apk"
  apk update

  log_header "Installing curl"
  apk add curl
}

# Enough with the functions, let's do stuff.
main() {

  set -e

  echo
  echo 'Dotfiles Install Script - Stephen Roberts'
  echo
  echo '༼ つ ◕_◕ ༽つMUST. HAVE. DOTFILES.༼ つ ◕_◕ ༽つ'
  echo

  # Show help/usage
  if [ "$1" = -h ] || [ "$1" = "--help" ]; then
    usage
    return 0
  fi

  # Get the current (target) OS
  os=$(get_os)

  # Ensure git is installed
  install_git "$os" || {
    log_error "Failed to find or install git!"
    return 1
  }

  # Download/update dotfiles only if we're not running with a restart after
  # already updating
  if [ "$1" != restart ]; then
    fetch_dotfiles || {
      echo "Dotfiles were updated. Restarting..."
      exec "$0" "restart"
    }
  fi

  "init_$os"
  install_things "$os"

  # Alert if backups were made.
  if [ -e "$BACKUPS" ]; then
    printf -- "\\nBackups were moved to ~/%s\\n" "${BACKUPS#$HOME/}"
  fi

  # All done!
  log_header "Note: You may need to log out and back in."
  log_header "Siiiick! You're ready to go! (•̀ᴗ•́)و"
}

main "$@"
