## dotfiles

export DOTFILES="$HOME/.dotfiles"
export PATH="$DOTFILES/bin:$PATH"

## Homebrew

[ -e /opt/homebrew/bin/brew ] && eval "$(/opt/homebrew/bin/brew shellenv)"

## grep

alias grep='grep --color=auto'

## Filesystem

# Files will be created with these permissions:
# files 644 -rw-r--r-- (666 minus 022)
# dirs  755 drwxr-xr-x (777 minus 022)
umask 022

## Aliases

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

# Trick to use unzip on systems that only have 7z
if ! type unzip >/dev/null 2>&1 && type 7z >/dev/null 2>&1; then
  alias unzip="7z e"
fi

# Source each installed module
for module in $(cat "$DOTFILES/.selected"); do
  source_file="$DOTFILES/modules/$module/source.sh"
  if [ -f "$source_file" ]; then
    . "$source_file"
  fi
done
