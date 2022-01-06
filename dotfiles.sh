#!/usr/bin/env sh
#####################################################################
# Dotfiles install script                                           #
#                                                                   #
# ༼ つ ◕_◕ ༽つMUST. HAVE. DOTFILES.༼ つ ◕_◕ ༽つ                     #
#                                                                   #
# Author: Stephen Roberts <stephenroberts@gmail.com>                #
#                                                                   #
# Usage: dotfiles [--help | -h]                                     #
#                                                                   #
#   See the README for documentation.                               #
#   https://github.com/stephencroberts/dotfiles                     #
#                                                                   #
#   Copyright (c) 2022 Stephen Roberts                              #
#   Licensed under the MIT license                                  #
#####################################################################

: "${REPO:=git://github.com/stephencroberts/dotfiles.git}"
: "${DOTFILES:=$HOME/.dotfiles}"
: "${CACHE_FILE:=$DOTFILES/.selected}"
: "${BACKUPS:=$DOTFILES/backups/$(date +%s)}"

############################################################################
# Prints usage to the screen, scraped from the documentation in the script #
# header                                                                   #
############################################################################
usage() {
  sed -n '3,/###/p' "$0" \
    | sed 's/# \(.*\) *#$/\1/' \
    | sed '$d'
}

###########
# Logging #
###########

log_header()   { printf -- '\n\033[1m%b\033[0m\n' "$@"; }
log_success()  { printf -- ' \033[1;32m✔\033[0m  %b\n' "$@"; }
log_error()    { printf -- ' \033[1;31m✖\033[0m  %b\n' "$@" >&2; }
log_arrow()    { printf -- ' \033[1;34m➜\033[0m  %b\n' "$@"; }

#######################################
# Symlinks a file                     #
#                                     #
# Note: this is used by the modules   #
#                                     #
# Arguments:                          #
#   - source                          #
#   - destination (defaults to $HOME) #
#######################################
link_file() {
  base=$(basename "$1")
  dst="${2:-$HOME/$base}"

  if [ -e "$dst" ]; then
    if [ "$1" = "$(readlink "$dst")" ]; then
      log_error "Skipping ~${dst#"$HOME"}, same file."
      return 0
    fi

    log_arrow "Backing up ~${dst#"$HOME"}."
    backup_file "$dst"
  fi

  log_success "Linking ~${dst#"$HOME"}"
  ln -sf "$1" "$dst"
}

#######################
# Gets the current OS #
#                     #
# Returns: the OS     #
#######################
get_os() {
  if [ "$(uname)" = Darwin ]; then
    echo macos
  elif [ -e /etc/alpine-release ]; then
    echo alpine
  elif [ -e /etc/os-release ] && grep debian >/dev/null 2>&1 </etc/os-release
  then
    echo debian
  else
    log_error "OS not supported!"
    return 1
  fi
}

#################################
# Installs git in the target OS #
#                               #
# Arguments:                    #
#   - os name                   #
#################################
install_git() {
  (type git >/dev/null 2>&1 && git --version >/dev/null) || {
    log_header "Installing git"
    "install_git_$1"
  }

  # Check that git is installed
  type git >/dev/null 2>&1 && git --version >/dev/null
}

###############################
# Instal git for alpine linux #
###############################
install_git_alpine() {
  apk add --update git
}

############################################################################
# Install git for macOS                                                    #
#                                                                          #
# The first time `git` is used, macOS prompts to install it, so let's wait #
# until the user says it's finished.                                       #
############################################################################
install_git_macos() {
  printf -- "Waiting for git to be installed. Press ENTER to continue."
  read -r
}

###########################
# Installs git for debian #
###########################
install_git_debian() {
  apt-get -qq install git-core
}



############################################
# Download or update dotfiles              #
#                                          #
# Returns: code 1 if dotfiles were updated #
############################################
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

##################################################
# ==================== MENU ==================== #
##################################################

################################
# Prints an option as selected #
#                              #
# Arguments:                   #
#   - option                   #
################################
prompt_print_selected() {
  printf -- ' \033[1;32m✔\033[0m  %b\n' "$@"
}

##################################
# Prints an option as deselected #
#                                #
# Arguments:                     #
#   - option                     #
##################################
prompt_print_deselected() {
  printf -- ' \033[1;31m✖\033[0m  %b\n' "$@"
}

##################################################
# Prints a menu with selected/deselected options #
#                                                #
# Arguments:                                     #
#   - heading                                    #
#   - all options                                #
#   - selected options                           #
##################################################
prompt_print_menu() {
  log_header "$1"

  i=1
  for option in $2; do
    if echo " $3" | grep " $option " >/dev/null; then
      prompt_print_selected "$i) $option"
    else
      prompt_print_deselected "$i) $option"
    fi
    i=$((i+1))
  done
}

#################################################################
# Gets an item by index (1-indexed) from a space-delimited list #
#                                                               #
# Arguments:                                                    #
#   - list                                                      #
#   - index                                                     #
#                                                               #
# Returns: the item at index                                    #
#################################################################
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

#############################################################################
# Prompts the user for selections from a menu                               #
#                                                                           #
# This function is recursive, printing the current menu as the user updates #
# selections until the user no longer makes new selections. The list of     #
# selected options is returned in a named variable.                         #
#                                                                           #
# Arguments:                                                                #
#   - heading                                                               #
#   - all menu options                                                      #
#   - selected menu options                                                 #
#   - wait time (s) for the user to interact with the menu (optional)       #
#                                                                           #
# Returns: the selected menu options in the variable `prompt_selections`    #
#############################################################################
prompt_menu() {
  heading=$1
  options=$2
  selected=$3

  prompt_print_menu "$heading" "$options" "$selected"

  # Continue asking the user for changes to the selections until they no longer
  # enter input
  printf -- '\r\033[K'
  if printf "Toggle options (Separate options with spaces, ENTER when done): " \
    && read -r nums \
    && [ -n "$(echo "$nums" | xargs)" ]; then

    for num in $nums; do

      # Get the menu option at the index the user selected
      option=$(get_item_at_index "$options" "$num")

      # Select/deselect the option
      if echo "$selected" | grep "$option" >/dev/null; then
        selected=$(echo "$selected" | sed "s/$option//")
      else
        selected="$selected$option "
      fi
    done

    # Recursive! Prompt the user for more changes.
    prompt_menu "$heading" "$options" "$selected"
  fi

  # Return final results
  export prompt_selections="$selected"
}

####################################################
# Executes install scripts as selected by the user #
#                                                  #
# Arguments:                                       #
#   - operating system                             #
####################################################
install_things() {
  menu_options=$(find "$DOTFILES/modules" -maxdepth 1 -mindepth 1 -type d \
    -exec basename {} \; | sort | xargs)

  if [ -f "$CACHE_FILE" ]; then
    menu_selects="$(xargs <"$CACHE_FILE") "
  fi

  prompt_menu 'Suh dude. Wanna install some stuff? ¯\\\_(ツ)\_/¯' \
    "$menu_options" "$menu_selects"

  # Write out cache file for future reading.
  echo "$prompt_selections" >"$CACHE_FILE"

  for option in $prompt_selections; do
    log_header "Installing $option"
    . "$DOTFILES/modules/$option/install.sh" "$1" "$2"
  done
}

#########################################
# Backs up a file to the backups folder #
#                                       #
# Arguments:                            #
#   - file                              #
#########################################
backup_file() {
  # Create backup dir if it doesn't already exist.
  [ -e "$BACKUPS" ] || mkdir -p "$BACKUPS"
  mv "$1" "$BACKUPS"
}

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
  brew install jq
}

# Sets up everything required for Debian
init_debian() {
  log_header "Updating apt"
  apt-get -qq update
  apt-get -qq dist-upgrade

  # I can't survive without jq
  log_header "Installing essentials"
  apt-get -qq install jq
}

init_alpine() {
  log_header "Updating apk"
  apk update

  log_header "Installing essentials"
  apk add curl jq
}

##############################################
# Enough with the functions, let's do stuff. #
##############################################
main() {

  set -e

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
  . "$DOTFILES/source.sh"

  # Alert if backups were made.
  if [ -e "$BACKUPS" ]; then
    printf -- "\\nBackups were moved to ~/%s\\n" "${BACKUPS#"$HOME"/}"
  fi

  # All done!
  log_header "Note: You may need to log out and back in."
  log_header "Siiiick! You're ready to go! (•̀ᴗ•́)و"
}

main "$@"
