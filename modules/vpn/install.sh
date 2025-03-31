#!/bin/sh

type op >/dev/null || {
	log_error "1Password CLI is required. Please install the apps module!"
	return 0
}

get_vpn_config() {
	echo "The VPN config and credentials are pulled from a 1Password secret with the following fields:"
	echo "  - username"
	echo "  - password"
	echo "  - authgroup"
	echo "  - website"
	echo
	printf -- "Account: "
	read -r account
	printf -- "Vault: "
	read -r vault
	printf -- "Secret: "
	read -r secret
}

if [ "$1" = macos ]; then
	brew_install openconnect
	brew_install vpn-slice
elif [ "$1" = debian ]; then
	apt_install openconnect
	apt_install python3-full
	sudo pip3 install "vpn-slice[dnspython,setproctitle]"
else
	type openconnect >/dev/null || {
		log_error "$1 is not supported!"
		return 0
	}
fi

mkdir -p "$HOME/.vpn"
touch "$HOME/.vpn/routes"

if ! grep "VPN_" <"$DOTFILES/.local" >/dev/null 2>&1; then
	get_vpn_config
	printf -- "\nexport VPN_ACCOUNT=\"%s\"\nexport VPN_VAULT=\"%s\"\nexport VPN_SECRET=\"%s\"" \
		"$account" "$vault" "$secret" >>"$DOTFILES/.local"
fi
