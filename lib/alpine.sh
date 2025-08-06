init_alpine() {
	log_header "Updating apk"
	apk update

	log_header "Installing essentials"
	apk_add coreutils # For the real `ls`
	apk_add curl
	apk_add jq
	apk_add procps # For the real `ps`
}

apk_add() {
	type "$1" >/dev/null || {
		log_header "Installing $1"
		apk add "$1"
	}
}

post_install_alpine() {
	:
}
