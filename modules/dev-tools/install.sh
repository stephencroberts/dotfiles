#!/bin/sh

if [ "$1" = debian ]; then
	apt_install inotify-tools

	# Use ctags as backend for global
	snap_install universal-ctags

	# Install GNU Global dependencies
	# https://www.gnu.org/software/global/download.html
	apt_install autoconf
	apt_install automake
	apt_install bison
	apt_install flex
	apt_install gperf
	apt_install libncurses5-dev
elif [ "$1" = macos ]; then
	brew_install jannis-baum/tap/vivify
	brew_install universal-ctags
	brew_install watch
else
	if ! type ctags >/dev/null && ctags --version |
		grep "Universal Ctags" /dev/null 2>&1; then
		log_error "$1 is not supported!"
		return 0
	fi
fi

######################
# GNU Global + ctags #
######################

# Install GNU Global from source
if ! type global >/dev/null; then
	log_header "Installing GNU Global"
	download_latest_from_ftp https://ftp.gnu.org/pub/gnu/global/ '[^"]*.gz' \
		global.tar.gz
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

link_file "$DOTFILES/modules/dev-tools/.globalrc"

#
# Mise
#

mise config set -f "$HOME/.config/mise/config.toml" \
	env.PROJECT_DIR \
	"{{ cwd }}"

mise config set -f "$HOME/.config/mise/config.toml" \
	env._.source \
	"$DOTFILES/modules/dev-tools/mise-dotfiles.sh"
