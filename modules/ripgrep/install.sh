if [ "$1" = macos ]; then
  brew list ripgrep >/dev/null || brew install ripgrep
elif [ "$1" = alpine ]; then
  type ripgrep >/dev/null || apk add ripgrep
elif [ "$1" = debian ]; then

  if ! type ripgrep >/dev/null; then

    # Try installing with apt with fallback to git
    apt-get install -qq ripgrep || {
      curl -LO https://github.com/BurntSushi/ripgrep/releases/download/13.0.0/r\
ipgrep_13.0.0_amd64.deb
      dpkg -i ripgrep_13.0.0_amd64.deb
    }
  fi

else
  log_error "$1 is not supported!"
  return 0
fi
