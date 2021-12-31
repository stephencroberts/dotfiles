#!/bin/sh

## dotfiles

export DOTFILES="$HOME/.dotfiles"
export PATH="$DOTFILES/bin:$PATH"

## asdf

type -p asdf >/dev/null && . $(brew --prefix asdf)/asdf.sh

## fzf

# Use ag for fzf
type -p ag >/dev/null && type -p fzf >/dev/null \
  && export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g ""'

## git

alias g='git'
function ga() { git add "${@:-.}"; } # Add all files by default
alias gp='git push'
alias gpa='gp --all'
alias gu='git pull'
alias gl='git log'
alias gg='gl --decorate --oneline --graph --date-order --all'
alias gs='git status'
alias gst='gs'
alias gd='git diff'
alias gdc='gd --cached'
alias gm='git commit -m'
alias gma='git commit -am'
alias gb='git branch'
alias gba='git branch -a'
function gc() { git checkout "${@:-master}"; } # Checkout master by default
alias gco='gc'
alias gcb='gc -b'
alias gr='git remote'
alias grv='gr -v'
alias gra='git remote add'
alias grr='git remote rm'
alias gcl='git clone'
alias gcd='git rev-parse 2>/dev/null && cd "./$(git rev-parse --show-cdup)"'

## grep

export GREP_OPTIONS='--color=auto'
## Filesystem

# Files will be created with these permissions:
# files 644 -rw-r--r-- (666 minus 022)
# dirs  755 drwxr-xr-x (777 minus 022)
umask 022

## Aliases

# Always use color output for `ls`
alias ls='command ls --color'
export LS_COLORS='no=00:fi=00:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:'

# Easier navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Recursively delete `.DS_Store` files
alias dsstore="find . -name '*.DS_Store' -type f -ls -delete"

# Easily re-execute the last history command.
alias r="fc -e -"

# Trim new lines and copy to clipboard
alias c="tr -d '\n' | pbcopy"

# Start ScreenSaver. This will lock the screen if locking is enabled.
alias ss="/System/Library/CoreServices/ScreenSaverEngine.app/Contents/MacOS/Sc"\
"reenSaverEngine"
