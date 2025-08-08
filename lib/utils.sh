#!/bin/sh

#######################################
# Symlinks a file                     #
#                                     #
# Note: this is used by the modules   #
#                                     #
# Arguments:                          #
#   - source                          #
#   - destination (defaults to $HOME) #
#######################################
link_file() {
	base=$(basename "$1")
	dst="${2:-$HOME/$base}"

	if [ -e "$dst" ]; then
		if [ "$1" = "$(readlink "$dst")" ]; then
			log_error "Skipping ~${dst#"$HOME"}, same file."
			return 0
		fi

		log_arrow "Backing up ~${dst#"$HOME"}."
		backup_file "$dst"
	fi

	log_success "Linking ~${dst#"$HOME"}"
	mkdir -p "$(dirname "$dst")"
	ln -sf "$1" "$dst"
}

#########################################
# Backs up a file to the backups folder #
#                                       #
# Arguments:                            #
#   - file                              #
#########################################
backup_file() {
	# Create backup dir if it doesn't already exist.
	[ -e "$BACKUPS" ] || mkdir -p "$BACKUPS"
	mv "$1" "$BACKUPS"
}

#######################
# Adds a path to PATH #
#                     #
# Arguments:          #
#   - path            #
#######################
path_add() {
	case ":$PATH:" in
	*":$1:"*) ;;
	*) export PATH="$1:$PATH" ;;
	esac
}

###########################################################
# Downloads the latest release of an artifact from GitHub #
#                                                         #
# Arguments:                                              #
#   - repo (e.g. asdf-vm/asdf)                            #
#   - regex pattern for artifact name                     #
#   - downloaded artifact name                            #
###########################################################
download_from_github() {
	curl --silent --show-error --fail-with-body --location \
		--output "$3" \
		"$(curl --silent --show-error --fail-with-body --location \
			"https://api.github.com/repos/$1/releases/latest" |
			jq -r '.assets
				| map(
						select(.browser_download_url | test("'"$2"'"))
					)
				| first
				| .browser_download_url')"
}

################################################################################
# Downloads the latest artifact from an FTP server that supports file listings #
#                                                                              #
# Arguments                                                                    #
#   - listing url (e.g. https://ftp.gnu.org/pub/gnu/global/)                   #
#   - pattern for matching inside the href tag (e.g. [^"]*.gz)                 #
#   - downloaded artifact name                                                 #
################################################################################
download_latest_from_ftp() {
	curl --silent --show-error --fail-with-body --location \
		--output "$3" \
		"$1$(curl --silent --show-error --fail-with-body --location \
			"$1" |
			grep -o 'href="'"$2"'"' |
			sed 's/href="\(.*\)"/\1/' |
			sort -V |
			tail -1)"
}
