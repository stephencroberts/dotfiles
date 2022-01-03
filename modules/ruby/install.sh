if [ "$1" = macos ]; then
  log_header "Installing asdf"
  . "$DOTFILES/init/asdf.sh"
fi

# TODO: install ruby
