#!/usr/bin/env sh
##########################################################################
# Dotfiles install script                                                #
#                                                                        #
# ༼ つ ◕_◕ ༽つMUST. HAVE. DOTFILES.༼ つ ◕_◕ ༽つ                          #
#                                                                        #
# Author: Stephen Roberts <stephenroberts@gmail.com>                     #
#                                                                        #
# TODO: Add docs                                                         #
#   - os-detection and git has to be in this file as it's sourced before #
#     the repo is downloaded                                             #
#   - libs                                                               #
#   - install helper                                                     #
#                                                                        #
# Usage: dotfiles [--help | -h]                                          #
#                                                                        #
#   See the README for documentation.                                    #
#   https://github.com/stephencroberts/dotfiles                          #
#                                                                        #
#   Copyright (c) 2022 Stephen Roberts                                   #
#   Licensed under the MIT license                                       #
##########################################################################

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
    log_error "OS not supported! Attempting to move forward. Good luck!"
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
    if [ "$1" = alpine ]; then
      apk add --update git
    elif [ "$1" = debian ]; then
      apt-get -qq install git-core
    elif [ "$1" = macos ]; then
      printf -- "Waiting for git to be installed. Press ENTER to continue."
      read -r
    fi
  }

  # Check that git is installed
  type git >/dev/null 2>&1 && git --version >/dev/null
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

##############################################################################
# Prompts the user for selections from a menu                                #
#                                                                            #
# This function is recursive, printing the current menu as the user updates  #
# selections until the user no longer makes new selections. The list of      #
# selected options is returned in a named variable.                          #
#                                                                            #
# To keep it simple, this uses VERY fragile string parsing with whitespace   #
# being critical. Every option must be surrounded by whitespace for matching #
# to work. This will not work in many other contexts!                        #
#                                                                            #
# Arguments:                                                                 #
#   - heading                                                                #
#   - all menu options                                                       #
#   - selected menu options                                                  #
#   - wait time (s) for the user to interact with the menu (optional)        #
#                                                                            #
# Returns: the selected menu options in the variable `prompt_selections`     #
##############################################################################
prompt_menu() {
  heading=$1
  options=$2
  selected=$3

  prompt_print_menu "$heading" "$options" "$selected"

  # Continue asking the user for changes to the selections until they no longer
  # enter input
  printf -- '\r\033[K'
  if printf "Toggle options (Separate options with spaces, ENTER when done): " \
    && read -r nums && [ -n "$(echo "$nums" | xargs)" ]; then

    for num in $nums; do

      # Get the menu option at the index the user selected
      option=$(get_item_at_index "$options" "$num")

      # Select/deselect the option
      if echo "$selected" | grep " $option " >/dev/null; then
        selected=$(echo "$selected" | sed "s/ $option//")
      else
        selected="$selected$option "
      fi
    done

    # Recursive! Prompt the user for more changes.
    prompt_menu "$heading" "$options" "$selected"
  fi

  # Return final results
  export prompt_selections=" $selected"
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
    menu_selects=" $(xargs <"$CACHE_FILE") "
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

  # Source all the libs
  for lib in $(find "$DOTFILES/lib" -name "*.sh"); do
    log_header "Sourcing $lib"
    . "$lib"
  done

  # Initialize the target os from magic functions in /lib
  [ -n "$os" ] && "init_$os"

  # Source dotfiles to get aliases and such
  . "$DOTFILES/source.sh"

  install_things "$os"

  # Alert if backups were made.
  if [ -e "$BACKUPS" ]; then
    printf -- "\\nBackups were moved to ~/%s\\n" "${BACKUPS#"$HOME"/}"
  fi

  # All done!
  log_header "Note: You may need to log out and back in."
  log_header "Siiiick! You're ready to go! (•̀ᴗ•́)و"
}

main "$@"
