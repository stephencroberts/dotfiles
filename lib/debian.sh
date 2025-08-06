apt_install() {
	type "$1" >/dev/null || {
		log_header "Installing $1"
		$maybe_sudo apt-get -qq install "$1"
	}
}

apt_remove() {
	if type "$1" >/dev/null; then
		$maybe_sudo apt-get -qq remove "$1"
	fi
}

snap_install() {
	type "$1" >/dev/null || {
		log_header "Installing $1"
		$maybe_sudo snap install "$1"
	}
}

# Sets up everything required for Debian
init_debian() {
	log_header "Updating apt"
	$maybe_sudo apt-get -qq update
	$maybe_sudo apt-get -qq dist-upgrade

	# I can't survive without jq
	log_header "Installing essentials"
	apt_install curl
	apt_install jq
	apt_install snapd
	apt_install xclip
}

post_install_debian() {
	:
}
