#!/bin/sh

# Source each installed module that has git hooks
# shellcheck disable=SC2013
for module in $(cat "$DOTFILES/.selected"); do
	file="$DOTFILES/modules/$module/direnv.sh"
	if [ -f "$file" ]; then
		# shellcheck disable=SC1090
		. "$file"
	fi
done
