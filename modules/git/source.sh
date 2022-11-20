export GPG_TTY=$(tty)
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
type gpg-agent >/dev/null && gpgconf --launch gpg-agent

alias g='git'
ga() { git add "${@:-.}"; } # Add all files by default
alias gp='git push'
alias gpa='gp --all'
alias gu='git pull'
alias gl='git log'
alias gg='gl --decorate --oneline --graph --date-order --all'
alias gs='git status'
alias gst='gs'
alias gd='git diff'
alias gdc='gd --cached'
alias gm='git commit -S -m'
alias gma='git commit -S -am'
alias gb='git branch'
alias gba='git branch -a'
alias gc='git checkout'
alias gcb='git checkout -b'
alias gr='git remote'
alias grv='gr -v'
alias gra='git remote add'
alias grr='git remote rm'
alias gcl='git clone'
alias gcd='git rev-parse 2>/dev/null && cd "./$(git rev-parse --show-cdup)"'
