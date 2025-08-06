if [ -f ~/.config/op/plugins.sh ]; then
	. ~/.config/op/plugins.sh
	# Run commands aliases by op without trying to load a secret from op
	alias opr="op run -- "
fi
