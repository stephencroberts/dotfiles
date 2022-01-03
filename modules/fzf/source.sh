[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Use ag for fzf
type ag >/dev/null && type fzf >/dev/null \
  && export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g ""'
