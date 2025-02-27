#!/bin/sh

type asdf >/dev/null || {
	log_error "Please install the asdf module!"
	return 0
}

asdf plugin list | grep rust >/dev/null || asdf plugin add rust
asdf install rust latest || true
asdf set -u rust latest

rustup component add clippy
rustup component add rust-analyzer
rustup component add rustfmt
