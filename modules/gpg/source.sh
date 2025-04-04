if type gpg-agent >/dev/null && type gpgconf >/dev/null; then
	GPG_TTY=$(tty)
	export GPG_TTY
	if [ -z "$SSH_CLIENT" ]; then
		SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
		export SSH_AUTH_SOCK
	fi
	gpgconf --launch gpg-agent
fi
