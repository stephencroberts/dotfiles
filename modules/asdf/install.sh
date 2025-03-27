#!/bin/sh

install_binary() {
	type asdf >/dev/null || {
		download_from_github asdf-vm/asdf "linux-amd64.*gz$" asdf.tar.gz
		tar -zxf asdf.tar.gz
		mkdir -p "$DOTFILES/modules/asdf/bin"
		mv asdf "$DOTFILES/modules/asdf/bin"
		rm asdf.tar.gz
	}
}

if [ "$1" = macos ]; then
	brew_install asdf
elif [ "$1" = alpine ]; then
	install_binary asdf
elif [ "$1" = debian ]; then
	install_binary asdf
else
	type asdf >/dev/null || {
		log_error "$1 is not supported!"
		return 0
	}
fi

mkdir -p "${ASDF_DATA_DIR:-$HOME/.asdf}/completions"
asdf completion zsh >"${ASDF_DATA_DIR:-$HOME/.asdf}/completions/_asdf"
