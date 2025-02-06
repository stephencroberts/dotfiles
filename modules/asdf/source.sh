# macos/homebrew
if brew --prefix asdf >/dev/null 2>&1; then
  export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"

  if [ "$CURRENT_SHELL" = zsh ]; then
    fpath=(${ASDF_DATA_DIR:-$HOME/.asdf}/completions $fpath)
    autoload -Uz compinit && compinit
  fi

# Non-homebrew, probably in the HOME directory
elif [ -e "$HOME/.asdf" ]; then

  # Load asdf
  if [ "$CURRENT_SHELL" = bash ] || [ "$CURRENT_SHELL" = zsh ]; then
    # shellcheck disable=SC1091
    . "$HOME/.asdf/asdf.sh"
  else
    echo "Shell not supported for asdf!" >&2
  fi

  # Load bash completions if using bash
  if [ "$CURRENT_SHELL" = bash ]; then
    # shellcheck disable=SC1091
    . "$HOME/.asdf/completions/asdf.bash"
  fi

# Did you install asdf correctly??
else
  echo "Failed to find asdf!" >&2
fi
