node_modules=$(npm root)
project=$(git rev-parse --show-toplevel)
if [ -e "$project/${node_modules##"$project"}" ]; then
	if [ -z "$GTAGSLIBPATH" ]; then
		export GTAGSLIBPATH="$node_modules"
	else
		export GTAGSLIBPATH="$GTAGSLIBPATH:$node_modules"
	fi
fi
