#!/bin/sh

if [ "$1" = macos ]; then
	brew_install autossh
	# Install X11 for clipboard syncing with remote hosts
	brew_cask_install xquartz
elif [ "$1" = debian ]; then
	apt_install libpam-ssh-agent-auth
	if [ ! -e /etc/sudoers.d/pam-ssh-agent-auth ]; then
		echo 'Defaults    env_keep += "SSH_AUTH_SOCK"' >pam-ssh-agent-auth
		$maybe_sudo chmod 440 pam-ssh-agent-auth
		$maybe_sudo chown root:root pam-ssh-agent-auth
		$maybe_sudo mv pam-ssh-agent-auth /etc/sudoers.d/

		$maybe_sudo sed -i '/PAM/a \\nauth    sufficient  pam_ssh_agent_auth.so file=~/.ssh/authorized_keys' /etc/pam.d/sudo
	fi
fi

mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"
link_file "$DOTFILES/modules/ssh/config" "$HOME/.ssh/config"
