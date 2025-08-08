#!/bin/sh

gems=$(gem environment |
	grep -- "- INSTALLATION DIRECTORY" | awk '{print $4}')/gems
if [ -e Gemfile ]; then
	if [ -z "$GTAGSLIBPATH" ]; then
		export GTAGSLIBPATH="$gems"
	else
		export GTAGSLIBPATH="$GTAGSLIBPATH:$gems"
	fi
fi
