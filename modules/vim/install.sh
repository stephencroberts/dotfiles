#!/bin/sh

if [ "$OS_NAME" = macos ]; then
	brew_install vim
elif [ "$OS_NAME" = debian ]; then
	apt_install vim-gtk3
elif [ "$OS_NAME" = alpine ]; then
	apk_add vim
else
	type vim >/dev/null || {
		log_error "$OS_NAME is not supported!"
		return 0
	}
fi

link_file "$DOTFILES/modules/vim/.vimrc"

# Install vim-plug if needed
[ -e ~/.vim/autoload/plug.vim ] || curl --fail --silent --show-error --location --output ~/.vim/autoload/plug.vim --create-dirs \
	https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Install vim plugins
vim +PlugInstall +qall
