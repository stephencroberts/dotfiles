#!/bin/sh

# Wrapper for bundle that generates gtags in the gems directory
# Works in conjunction with mise to load the library
bundle() {
	command bundle "$@"

	arg1="$1"
	# All of the commands and aliases from the docs that affect packages
	set -- add install remove update

	for c in "$@"; do
		if [ "$arg1" = "$c" ]; then
			# Imporant! Unset args.
			set --
			wd=$(pwd)
			# Go into the gems directory
			cd "$(gem environment | grep -- "- INSTALLATION DIRECTORY" | awk '{print $4}')/gems" || return

			echo "Generating gtags in $PWD"
			find . -type f -name "*.rb" -print | gtags --file -

			cd "$wd" || return
		fi
	done
}
