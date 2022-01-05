# asdf must be loaded differently depending on shell. This may be a bit fragile,
# but quickly checks where asdf is located and which shell to decide what to
# load.

# asdf doesn't work in bourne shell
echo "$0" | grep '\(^\|.*\/\)sh$' >/dev/null 2>&1 && return 0

# macos/homebrew
if type brew >/dev/null 2>&1 && brew --prefix asdf >/dev/null 2>&1; then

  # Load asdf
  . "$(brew --prefix asdf)/asdf.sh"

  # Load bash completions if using bash
  echo "$0" | grep bash >/dev/null 2>&1 \
    && "$(brew --prefix asdf)/etc/bash_completion.d/asdf.bash"

# Non-homebrew, probably in the HOME directory
elif [ -e "$HOME/.asdf" ]; then

  # Load asdf
  . "$HOME/.asdf/asdf.sh"

  # Load bash completions if using bash
  echo "$0" | grep bash >/dev/null 2>&1 && . "$HOME/.asdf/completions/asdf.bash"

# Did you install asdf correctly??
else
  log_error "Failed to find asdf!"
  return 0
fi
