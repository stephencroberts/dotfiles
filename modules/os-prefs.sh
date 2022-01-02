if [ "$1" = macos ]; then
  # macOS Preferences
  #
  # Key/value pairs are in ~/Library/Preferences. Apple binary property lists can
  # be converted to XML in-place with `plutil -convert xml1 <plist>`.

  ## Dock Settings
  # https://developer.apple.com/documentation/devicemanagement/dock

  # Enables "Automatically hide and show the dock."
  defaults write com.apple.dock autohide -bool true

  # Shows the process indicator.
  defaults write com.apple.dock show-process-indicators -bool true

  # Enables "Show recent items."
  defaults write com.apple.dock show-recents -bool true

  # Uses the static-apps and static-others dictionaries for the dock and ignores
  # any items in the persistent-apps and persistent-others dictionaries. If false,
  # the contents are merged with the static items listed first.
  defaults write com.apple.dock static-only -bool true

  # Changes the Dock opening and closing animation times.
  # https://macos-defaults.com/dock/autohide-time-modifier.html
  defaults write com.apple.dock autohide-time-modifier -float 0.2
  defaults write com.apple.dock autohide-delay -float 0

  # The tile size. Values must be in the range from 16 to 128.
  defaults write com.apple.dock tilesize -int 64

  killall Dock

  ## Global Settings

  # Auto-hides the menubar.
  defaults write -g _HIHideMenuBar -bool true

  # Speeds up the keyboard.
  defaults write -g InitialKeyRepeat -int 10
  defaults write -g KeyRepeat -int 1

  # Speeds up the trackpad.
  defaults write -g com.apple.trackpad.scaling -float 2
fi
