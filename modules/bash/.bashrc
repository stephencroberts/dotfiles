source "$HOME/.dotfiles/source/dotfiles.sh"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

. $(brew --prefix asdf)/libexec/asdf.sh
. $(brew --prefix asdf)/etc/bash_completion.d/asdf.bash
