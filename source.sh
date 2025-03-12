## dotfiles

export DOTFILES="$HOME/.dotfiles"
. "$DOTFILES/lib/utils.sh"
path_add "$DOTFILES/bin"
# shellcheck disable=SC2009
CURRENT_SHELL=$(ps -p $$ -oargs= | tr -d - | awk '{print $1}') || {
	echo "Failed to detect the current shell!" >&2
}
export CURRENT_SHELL

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
# shellcheck disable=SC2013
for module in $(cat "$DOTFILES/.selected"); do
	source_file="$DOTFILES/modules/$module/source.sh"
	if [ -f "$source_file" ]; then
		# shellcheck disable=SC1090
		. "$source_file"
	fi
done

# Source stuff for just this machine
if [ -e "$DOTFILES/.local" ]; then
	# shellcheck disable=SC1090
	. "$DOTFILES/.local"
fi
