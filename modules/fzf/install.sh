if [ "$1" = macos ]; then

  if ! brew list fzf >/dev/null; then
    brew install fzf
    "$(brew --prefix)/opt/fzf/install"
  fi

elif [ "$1" = alpine ]; then
  type fzf >/dev/null || apk add fzf

elif [ "$1" = debian ]; then

  if ! type fzf >/dev/null; then

    # Try installing with apt with fallback to git
    apt-get install -qq fzf || {
      git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
      "$HOME/.fzf/install"
    }
  fi
else
  log_error "$1 is not supported!"
fi
