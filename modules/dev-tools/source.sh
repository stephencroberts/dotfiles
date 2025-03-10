export GTAGSCONF=/usr/local/share/gtags/gtags.conf
export GTAGSLABEL=universal-ctags

if [ "$CURRENT_SHELL" = zsh ]; then
	eval "$(direnv hook zsh)"
elif [ "$CURRENT_SHELL" = bash ]; then
	eval "$(direnv hook bash)"
fi
