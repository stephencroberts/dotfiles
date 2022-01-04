[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Use rg for fzf
type rg >/dev/null && type fzf >/dev/null \
  && export FZF_DEFAULT_COMMAND='rg --files --hidden --glob=!.git'
