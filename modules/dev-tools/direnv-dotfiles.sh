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

# Find nested gtags databases in the project
libs=$(
	find . -mindepth 2 -maxdepth "${GTAGS_MAX_DEPTH:-5}" \
		-name GTAGS \
		-print0 |
		xargs -0 realpath |
		xargs dirname |
		tr '\n' ':'
)
libs="${libs%:}"

if [ -n "$libs" ]; then
	if [ -z "$GTAGSLIBPATH" ]; then
		export GTAGSLIBPATH="$libs"
	else
		export GTAGSLIBPATH="$libs:$GTAGSLIBPATH"
	fi
fi
