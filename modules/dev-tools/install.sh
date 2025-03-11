#!/bin/sh

type asdf >/dev/null || {
	log_error "Please install the asdf module!"
	return 0
}

########
# just #
########

asdf plugin list | grep just >/dev/null || asdf plugin add just
asdf install just latest || true
asdf set -u just latest

######################
# GNU Global + ctags #
######################

if [ "$1" = debian ]; then
	apt_install inotify-tools

	# Use ctags as backend for global
	snap_install universal-ctags

	# Install GNU Global dependencies
	# https://www.gnu.org/software/global/download.html
	apt_install automake
	apt_install autoconf
	apt_install gperf
	apt_install bison
	apt_install flex
elif [ "$1" = macos ]; then
	brew_install direnv
	brew_install universal-ctags
	brew_install watch
else
	if ! type ctags >/dev/null && ctags --version | grep "Universal Ctags" /dev/null 2>&1; then
		log_error "$1 is not supported!"
		return 0
	fi
fi

# Install GNU Global from source
if ! type global >/dev/null; then
	log_header "Installing GNU Global"
	curl -fSs -o global.tar.gz https://ftp.gnu.org/pub/gnu/global/global-6.6.14.tar.gz
	tar -zxf global.tar.gz
	rm global.tar.gz
	wd=$(pwd)
	cd global-* || {
		log_error "Failed to change directory to global"
		return 1
	}
	./configure --with-universal-ctags="$(which ctags)"
	make
	sudo make install
	cp -- *.vim "$DOTFILES/modules/dev-tools/"
	cd "$wd" || {
		log_error "Failed to change directory from global to working directory!"
		return 1
	}
	rm -rf global-*
fi

##########
# Vivify #
##########

if [ "$1" = macos ]; then
	brew_install jannis-baum/tap/vivify
fi
