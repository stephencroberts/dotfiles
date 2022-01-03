# Use ag for fzf
type -p ag >/dev/null && type -p fzf >/dev/null \
  && export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g ""'
