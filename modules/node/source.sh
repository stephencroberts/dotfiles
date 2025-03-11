# Wrapper for npm that generates gtags in the node_modules directory
# Works in conjunction with direnv (./direnv.sh) to load the library
npm() {
	command npm "$@"

	arg1="$1"
	# All of the commands and aliases from the docs that affect packages
	set -- ci clean-install ic install-clean isntall-clean install add i in ins inst insta instal isnt isnta isntal isntall uninstall unlink remove rm r un update up upgrade udpate

	for c in "$@"; do
		if [ "$arg1" = "$c" ]; then
			# Imporant! Unset args.
			set --
			wd=$(pwd)
			# Go into the node_modules directory
			cd "$(npm root)" || return

			echo "Generating gtags in $PWD"

			# Gather the production dependencies with a depth level of 1 to get a lot
			# but not too many (hopefully!) to index; feed them to gtags
			IFS=$'\n'
			for f in $(npm ls --omit=dev --depth="${GTAGS_NPM_DEPTH:-0}" --json |
				jq -r '[.. | .dependencies? // empty | keys] | add | join("\n")'); do
				# Try to filter some of the garb; people are real dumb
				find "$f" -path '*node_modules*' -prune \
					-o -path '*dist*' -prune \
					-o -path '@babel/*' -prune \
					-o -path 'esbuild/*' -prune \
					-o -path 'prettier/*' -prune \
					-o -type f -print
			done | gtags --accept-dotfiles --file -
			cd "$wd" || return
		fi
	done
}
