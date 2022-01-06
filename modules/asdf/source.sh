# macos/homebrew
if brew --prefix asdf >/dev/null 2>&1; then

  # Load asdf
  . "$(brew --prefix asdf)/asdf.sh"

  # Load bash completions if using bash
  [ -n "$BASH_VERSION" ] \
    && "$(brew --prefix asdf)/etc/bash_completion.d/asdf.bash"

# Non-homebrew, probably in the HOME directory
elif [ -e "$HOME/.asdf" ]; then

  # Load asdf
  if [ -n "$ZSH_VERSION" ] || [ -n "$BASH_VERSION" ]; then
    . "$HOME/.asdf/asdf.sh"
  else
    echo "Shell not supported for asdf!" >&2
  fi

  # Load bash completions if using bash
  [ -n "$BASH_VERSION" ] && . "$HOME/.asdf/completions/asdf.bash"

# Did you install asdf correctly??
else
  echo "Failed to find asdf!" >&2
fi
