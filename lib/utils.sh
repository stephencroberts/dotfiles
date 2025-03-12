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
