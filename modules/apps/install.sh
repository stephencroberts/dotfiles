#!/bin/sh

if [ "$1" = macos ]; then
  # mas is a cli for the App Store
  # https://github.com/mas-cli/mas
  brew_install 1password
  brew_install mas
  brew_cask_install docker
  brew_cask_install postman
  brew_cask_install visual-studio-code

  mas list | grep "Evernote" >/dev/null|| mas install 406056744 # Evernote
  mas list | grep "Slack" >/dev/null|| mas install 803453959 # Slack

  if ! brew list --cask iterm2 >/dev/null; then
    brew_cask_install iterm2

    # Specify the preferences directory
    defaults write com.googlecode.iterm2.plist PrefsCustomFolder \
      -string "~/.iterm2"
    # Tell iTerm2 to use the custom preferences in the directory
    defaults write com.googlecode.iterm2.plist LoadPrefsFromCustomFolder \
      -bool true
  fi

  link_file "$DOTFILES/modules/apps/.iterm2"
else
  log_error "$1 is not supported!"
  return 0
fi
