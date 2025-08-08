#!/bin/sh

export GTAGSLABEL=universal-ctags

if [ "$CURRENT_SHELL" = zsh ]; then
	eval "$(mise activate zsh)"
elif [ "$CURRENT_SHELL" = bash ]; then
	eval "$(mise activate bash)"
fi
