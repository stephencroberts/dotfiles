#!/bin/sh

type asdf >/dev/null || {
	log_error "Please install the asdf module!"
	return 0
}

asdf plugin list | grep nodejs >/dev/null ||
	asdf plugin add \
		nodejs https://github.com/asdf-vm/asdf-nodejs.git
asdf install nodejs latest || true
asdf set -u nodejs latest

link_file "$DOTFILES/modules/node/direnv.sh" \
	"$HOME/.config/direnv/lib/dotfiles-node.sh"
