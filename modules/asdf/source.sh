if type brew >/dev/null 2>&1 && brew --prefix asdf >/dev/null 2>&1; then
  . "$(brew --prefix asdf)/asdf.sh"
  echo "$0" | grep bash >/dev/null 2>&1 \
    && "$(brew --prefix asdf)/etc/bash_completion.d/asdf.bash"
elif [ -e "$HOME/.asdf" ]; then
  . "$HOME/.asdf/asdf.sh"
  echo "$0" | grep bash >/dev/null 2>&1 && . "$HOME/.asdf/completions/asdf.bash"
else
  log_error "Failed to find asdf!"
  return 0
fi
