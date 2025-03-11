#!/bin/sh

if [ "$1" = macos ]; then
	brew_install git
	brew_install git-delta
	brew_install lazygit
elif [ "$1" = alpine ]; then
	apk_add git
elif [ "$1" = debian ]; then
	apt_install git
else
	type git >/dev/null || {
		log_error "$1 is not supported!"
		return 0
	}
fi

link_file "$DOTFILES/modules/git/.gitconfig"
link_file "$DOTFILES/modules/git/.gitignore_global"
link_file "$DOTFILES/modules/git/hooks/post-checkout" "$HOME/.git_template/hooks/post-checkout"
link_file "$DOTFILES/modules/git/hooks/post-commit" "$HOME/.git_template/hooks/post-commit"
link_file "$DOTFILES/modules/git/hooks/post-merge" "$HOME/.git_template/hooks/post-merge"
link_file "$DOTFILES/modules/git/hooks/post-rewrite" "$HOME/.git_template/hooks/post-rewrite"
