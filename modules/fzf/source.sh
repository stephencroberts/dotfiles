# fzf auto-completions do not work in bourne shell
echo "$0" | grep '\(^\|.*\/\)sh$' >/dev/null 2>&1 && return 0

echo "$0" | grep "zsh" >/dev/null 2>&1 && [ -f ~/.fzf.zsh ] && . ~/.fzf.zsh
echo "$0" | grep "bash" >/dev/null 2>&1 && [ -f ~/.fzf.bash ] && . ~/.fzf.bash

# Use rg for fzf
type rg >/dev/null 2>&1 && type fzf >/dev/null 2>&1 \
  && export FZF_DEFAULT_COMMAND='rg --files --hidden --glob=!.git'
