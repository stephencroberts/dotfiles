#!/bin/sh

if [ "$OS_NAME" = macos ]; then
	brew_install colima
	brew services restart colima
	brew_install docker
	brew_install docker-buildx
	brew_install docker-compose

	mkdir -p "$HOME/.docker/cli-plugins"
	ln -sf "$(which docker-buildx)" "$HOME/.docker/cli-plugins/docker-buildx"

	# Add ssh integration to local config to avoid having it committed since the
	# module may not be installed
	if ! grep '.colima/ssh_config' <"$HOME/.ssh/config" 2>&1 >/dev/null; then
		printf -- "\nInclude /Users/%s/.colima/ssh_config\n" \
			"$USER" >>"$HOME/.ssh/config.local"
	fi
elif [ "$OS_NAME" = debian ]; then
	# https://docs.docker.com/engine/install/ubuntu/
	for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do
		apt_remove "$pkg"
	done

	if [ ! -e /etc/apt/keyrings/docker.asc ]; then
		# Add Docker's official GPG key:
		apt_install ca-certificates
		# shellcheck disable=SC2154
		$maybe_sudo install -m 0755 -d /etc/apt/keyrings
		$maybe_sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
		$maybe_sudo chmod a+r /etc/apt/keyrings/docker.asc

		# Add the repository to Apt sources:
		# shellcheck disable=SC1091
		echo \
			"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
      $(. /etc/os-release && echo "$VERSION_CODENAME") stable" |
			$maybe_sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
		$maybe_sudo apt-get update
	fi

	for pkg in docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin; do
		apt_install "$pkg"
	done

	getent group | grep "^docker:" >/dev/null 2>&1 || $maybe_sudo groupadd docker
	groups "$USER" | grep docker >/dev/null 2>&1 ||
		$maybe_sudo usermod -aG docker "$USER"

	apt_install docker-buildx-plugin
	apt_install docker-compose-plugin
else
	type docker >/dev/null || {
		log_error "$OS_NAME is not supported!"
		return 0
	}
fi
