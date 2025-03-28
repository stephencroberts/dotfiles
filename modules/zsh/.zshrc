#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

export ORIGINAL_SSH_AUTH_SOCK="${ORIGINAL_SSH_AUTH_SOCK:-$SSH_AUTH_SOCK}"

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Keep prompt on the same line
PROMPT='
${(e)$(prompt_paradox_build_prompt)} '

# Remove user@host from prompt
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  function prompt_paradox_build_prompt {
    prompt_paradox_start_segment black default '%(?::%F{red}✘ )%(!:%F{yellow}⚡ :)%(1j:%F{cyan}⚙ :)'
    prompt_paradox_start_segment blue black '$_prompt_paradox_pwd'

    if [[ -n "$git_info" ]]; then
      prompt_paradox_start_segment green black '${(e)git_info[ref]}${(e)git_info[status]}'
    fi

    if [[ -n "$python_info" ]]; then
      prompt_paradox_start_segment white black '${(e)python_info[virtualenv]}'
    fi

    prompt_paradox_end_segment
  }
fi

if type zoxide >/dev/null; then
  eval "$(zoxide init zsh)"
fi

source "$HOME/.dotfiles/source.sh"
