#!/bin/sh

# Ensure gcloud is in the PATH
if [ -d /usr/local/google-cloud-sdk ]; then
	path_add "/usr/local/google-cloud-sdk/bin"
fi

## Auto-completion

if [ -d /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk ]; then
	gsdk_dir=/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk
elif [ -d /usr/local/google-cloud-sdk ]; then
	gsdk_dir=/usr/local/google-cloud-sdk
fi

if [ "$CURRENT_SHELL" = bash ] && [ -e "$gsdk_dir/completion.bash.inc" ]; then
	# shellcheck disable=SC1091
	. "$gsdk_dir/completion.bash.inc"
fi

if [ "$CURRENT_SHELL" = zsh ] && [ -e "$gsdk_dir/completion.zsh.inc" ]; then
	# shellcheck disable=SC1091
	. "$gsdk_dir/completion.zsh.inc"
fi
