#!/bin/sh

type asdf >/dev/null || {
	log_error "Please install the asdf module!"
	return 0
}

asdf plugin list | grep ruby >/dev/null ||
	asdf plugin add ruby https://github.com/asdf-vm/asdf-ruby.git
asdf install ruby latest || true
asdf set -u ruby latest

link_file "$DOTFILES/modules/ruby/direnv.sh" \
	"$HOME/.config/direnv/lib/dotfiles-ruby.sh"
