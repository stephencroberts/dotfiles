if [ "$CURRENT_SHELL" = zsh ] && [ -f ~/.fzf.zsh ]; then
  # shellcheck disable=SC1090
  . ~/.fzf.zsh
fi

if [ "$CURRENT_SHELL" = bash ] && [ -f ~/.fzf.bash ]; then
  # shellcheck disable=SC1090
  . ~/.fzf.bash
fi

# Use rg for fzf
if type rg >/dev/null 2>&1 && type fzf >/dev/null 2>&1; then
  export FZF_DEFAULT_COMMAND='rg --files --hidden --glob=!.git'
fi

# Enable key bindings and auto-completion
if [ "$CURRENT_SHELL" != sh ] && [ -d /usr/share/doc/fzf/examples ]; then
  . /usr/share/doc/fzf/examples/key-bindings.zsh
  . /usr/share/doc/fzf/examples/completion.zsh
fi
