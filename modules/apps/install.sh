#!/bin/sh

if [ "$1" = macos ]; then
  # mas is a cli for the App Store
  # https://github.com/mas-cli/mas
  brew_install mas
  brew_cask_install docker
  brew_cask_install postman
  brew_cask_install visual-studio-code

  mas list | grep "1Password" >/dev/null|| mas install 1333542190 # 1Password
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

  if ! brew list --cask divvy >/dev/null; then
    brew_cask_install divvy

    echo "Open Divvy to finish installation. Press ENTER to continue."
    read

    open divvy://import/YnBsaXN0MDDUAQIDBAUGm5xYJHZlcnNpb25YJG9iamVjdHNZJGFyY2hpdmVyVCR0b3ASAAGGoK8QHgcIGjAxOD9AR0hPUFdYX2BnaG9wd3h/gIaHjo+Wl1UkbnVsbNIJCgsZWk5TLm9iamVjdHNWJGNsYXNzrQwNDg8QERITFBUWFxiAAoAFgAeACYALgA2AD4ARgBOAFYAXgBmAG4Ad3RscHR4fCiAhIiMkJSYnKCkqKiwoLScuLykpWHNpemVSb3dzXxAPc2VsZWN0aW9uRW5kUm93XxARc2VsZWN0aW9uU3RhcnRSb3dac3ViZGl2aWRlZFZnbG9iYWxfEBJzZWxlY3Rpb25FbmRDb2x1bW5XZW5hYmxlZFtzaXplQ29sdW1uc1duYW1lS2V5XGtleUNvbWJvQ29kZV8QFHNlbGVjdGlvblN0YXJ0Q29sdW1uXWtleUNvbWJvRmxhZ3MQBhAFEAAICIAECYADEAJURnVsbNIyMzQ1WiRjbGFzc25hbWVYJGNsYXNzZXNYU2hvcnRjdXSiNjdYU2hvcnRjdXRYTlNPYmplY3TdGxwdHh8KICEiIyQlJicoKSoqLC8tJz0+KSkICIAECYAGEAFYMS8yIExlZnTdGxwdHh8KICEiIyQlJicoKSoqLCgtJ0VGRikICIAECYAIEANZMS8yIFJpZ2h03RscHR4fCiAhIiMkJSYnLykqKiwoLSdNTikpCAiABAmAChAOVzEvMiBUb3DdGxwdHh8KICEiIyQlJicoRioqLCgtJ1VWKSkICIAECYAMEAhaMS8yIEJvdHRvbd0bHB0eHwogISIjJCUmJy8pKiosLy0nXV4pKQgIgAQJgA4QDVwxLzQgVG9wIExlZnTdGxwdHh8KICEiIyQlJicvKSoqLCgtJ2VmRikICIAECYAQEA9dMS80IFRvcCBSaWdodN0bHB0eHwogISIjJCUmJyhGKiosLy0nbW4pKQgIgAQJgBIQB18QDzEvNCBCb3R0b20gTGVmdN0bHB0eHwogISIjJCUmJyhGKiosKC0ndXZGKQgIgAQJgBQQCV8QEDEvNCBCb3R0b20gUmlnaHTdGxwdHh8KICEiIyQlJicvKSoqLCktJ31+KSkICIAECYAWEAxdMS8xMiBUb3AgTGVmdN0bHB0eHwogISIjJCUmJyhGKiosKS0nhScpKQgIgAQJgBhfEBAxLzEyIEJvdHRvbSBMZWZ03RscHR4fCiAhIiMkJSYnLykqKiwoLSeMjSgpCAiABAmAGhARXjEvMTIgVG9wIFJpZ2h03RscHR4fCiAhIiMkJSYnKEYqKiwoLSeUlSgpCAiABAmAHBALXxARMS8xMiBCb3R0b20gUmlnaHTSMjOYmV5OU011dGFibGVBcnJheaOYmjdXTlNBcnJheV8QD05TS2V5ZWRBcmNoaXZlctGdnlRyb290gAEACAARABoAIwAtADIANwBYAF4AYwBuAHUAgwCFAIcAiQCLAI0AjwCRAJMAlQCXAJkAmwCdAJ8AugDDANUA6QD0APsBEAEYASQBLAE5AVABXgFgAWIBZAFlAWYBaAFpAWsBbQFyAXcBggGLAZQBlwGgAakBxAHFAcYByAHJAcsBzQHWAfEB8gHzAfUB9gH4AfoCBAIfAiACIQIjAiQCJgIoAjACSwJMAk0CTwJQAlICVAJfAnoCewJ8An4CfwKBAoMCkAKrAqwCrQKvArACsgK0AsIC3QLeAt8C4QLiAuQC5gL4AxMDFAMVAxcDGAMaAxwDLwNKA0sDTANOA08DUQNTA2EDfAN9A34DgAOBA4MDlgOxA7IDswO1A7YDuAO6A8kD5APlA+YD6APpA+sD7QQBBAYEFQQZBCEEMwQ2BDsAAAAAAAACAQAAAAAAAACfAAAAAAAAAAAAAAAAAAAEPQ==
  fi
else
  log_error "$1 is not supported!"
  return 0
fi
