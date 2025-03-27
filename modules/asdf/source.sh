path_add "$DOTFILES/modules/asdf/bin"
path_add "${ASDF_DATA_DIR:-$HOME/.asdf}/shims"

if [ "$CURRENT_SHELL" = zsh ]; then
	FPATH="${ASDF_DATA_DIR:-$HOME/.asdf}/completions:$FPATH"
	autoload -Uz compinit && compinit
elif [ "$CURRENT_SHELL" = bash ]; then
	# shellcheck disable=SC1090
	eval "$(asdf completion bash)"
fi
