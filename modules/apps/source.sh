#!/bin/sh

if [ -f ~/.config/op/plugins.sh ]; then
	# shellcheck disable=SC1090
	. ~/.config/op/plugins.sh
	# Run commands aliases by op without trying to load a secret from op
	alias opr="op run --no-masking -- "
fi
