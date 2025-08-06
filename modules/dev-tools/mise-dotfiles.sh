#!/bin/sh

: "${PROJECT_DIR?}"
: "${GTAGS_MAX_DEPTH:=5}"

# Source each installed module that has git hooks
# shellcheck disable=SC2013
for module in $(cat "$DOTFILES/.selected"); do
	file="$DOTFILES/modules/$module/mise.sh"
	if [ -f "$file" ]; then
		# shellcheck disable=SC1090
		. "$file"
	fi
done

# Try to find the root of the git repo to start searching for GTAGS with the
# configured max depth, but fallback to the current directory and only search
# that directory to avoid deep searching arbitrary directories
if project_dir=$(cd "$PROJECT_DIR" && git rev-parse --show-toplevel); then
	max_depth="$GTAGS_MAX_DEPTH"
else
	project_dir="$PROJECT_DIR"
	max_depth=1
fi

# Find nested gtags databases in the project
libs=$(
	# Note: PROJECT_DIR is set in mise global config
	find "$project_dir" -mindepth 1 -maxdepth "$max_depth" \
		-name GTAGS \
		-print0 |
		xargs -r -0 realpath |
		xargs -r dirname |
		tr '\n' ':'
)
export GTAGSLIBPATH="${libs%:}"
