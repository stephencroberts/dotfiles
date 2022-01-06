[ -n "$ZSH_VERSION" ] && [ -f ~/.fzf.zsh ] && . ~/.fzf.zsh
[ -n "$BASH_VERSION" ] && [ -f ~/.fzf.bash ] && . ~/.fzf.bash

# Use rg for fzf
type rg >/dev/null 2>&1 && type fzf >/dev/null 2>&1 \
  && export FZF_DEFAULT_COMMAND='rg --files --hidden --glob=!.git'
