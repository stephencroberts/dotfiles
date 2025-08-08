#!/bin/sh

if [ "$OS_NAME" = macos ]; then
	brew_install git
	brew_install git-delta
	brew_install git-lfs
	brew_install lazygit
elif [ "$OS_NAME" = alpine ]; then
	apk_add git
elif [ "$OS_NAME" = debian ]; then
	apt_install git
	snap_install lazygit-gm
else
	type git >/dev/null || {
		log_error "$OS_NAME is not supported!"
		return 0
	}
fi

link_file "$DOTFILES/modules/git/.gitconfig"
link_file "$DOTFILES/modules/git/.gitignore_global"
link_file "$DOTFILES/modules/git/hooks/post-checkout" "$HOME/.git_template/hooks/post-checkout"
link_file "$DOTFILES/modules/git/hooks/post-commit" "$HOME/.git_template/hooks/post-commit"
link_file "$DOTFILES/modules/git/hooks/post-merge" "$HOME/.git_template/hooks/post-merge"
link_file "$DOTFILES/modules/git/hooks/post-rewrite" "$HOME/.git_template/hooks/post-rewrite"
link_file "$DOTFILES/modules/git/hooks/pre-push" "$HOME/.git_template/hooks/pre-push"
