#!/bin/sh

if [ "$OS_NAME" = macos ]; then
	brew_install 1password
	brew_install 1password-cli
	# mas is a cli for the App Store
	# https://github.com/mas-cli/mas
	brew_install mas
	brew_cask_install arc
	brew_cask_install elgato-control-center
	brew_cask_install microsoft-teams
	brew_cask_install postman
	brew_cask_install syncthing
	brew_cask_install utm
	brew_cask_install visual-studio-code

	mas list | grep "1Password for Safari" >/dev/null || mas install 1569813296
	mas list | grep "MeetingBar" >/dev/null || mas install 1532419400
	mas list | grep "Microsoft Outlook" >/dev/null || mas install 985367838
	mas list | grep "Slack" >/dev/null || mas install 803453959
	mas list | grep "Toggl" >/dev/null || mas install 1291898086

	if ! brew list --cask iterm2 >/dev/null; then
		brew_cask_install iterm2

		# Specify the preferences directory
		# shellcheck disable=SC2088
		defaults write com.googlecode.iterm2.plist PrefsCustomFolder \
			-string "~/.iterm2"
		# Tell iTerm2 to use the custom preferences in the directory
		defaults write com.googlecode.iterm2.plist LoadPrefsFromCustomFolder \
			-bool true
	fi

	link_file "$DOTFILES/modules/apps/.iterm2"
elif [ "$OS_NAME" = debian ]; then
	# Syncthing
	# https://apt.syncthing.net
	if ! [ -f /etc/apt/keyrings/syncthing-archive-keyring.gpg ]; then
		# Add the release PGP keys:
		sudo mkdir -p /etc/apt/keyrings
		sudo curl -L -o /etc/apt/keyrings/syncthing-archive-keyring.gpg https://syncthing.net/release-key.gpg

		# Add the "stable" channel to your APT sources:
		echo "deb [signed-by=/etc/apt/keyrings/syncthing-archive-keyring.gpg] https://apt.syncthing.net/ syncthing stable" | sudo tee /etc/apt/sources.list.d/syncthing.list

		init_debian
	fi

	apt_install syncthing
	# https://docs.syncthing.net/users/autostart.html#using-systemd
	# shellcheck disable=SC2154
	$maybe_sudo systemctl enable "syncthing@$USER.service"
	$maybe_sudo systemctl start "syncthing@$USER.service"
	# Make accessible
	syncthing cli config gui raw-address set 0.0.0.0:8384

	# Install 1password-cli
	# https://developer.1password.com/docs/cli/get-started/
	if ! type op >/dev/null; then
		curl -sS https://downloads.1password.com/linux/keys/1password.asc |
			$maybe_sudo gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg
		echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/$(dpkg --print-architecture) stable main" |
			sudo tee /etc/apt/sources.list.d/1password.list
		sudo mkdir -p /etc/debsig/policies/AC2D62742012EA22/
		curl -sS https://downloads.1password.com/linux/debian/debsig/1password.pol |
			sudo tee /etc/debsig/policies/AC2D62742012EA22/1password.pol
		sudo mkdir -p /usr/share/debsig/keyrings/AC2D62742012EA22
		curl -sS https://downloads.1password.com/linux/keys/1password.asc |
			sudo gpg --dearmor --output /usr/share/debsig/keyrings/AC2D62742012EA22/debsig.gpg
		sudo apt update
		sudo apt install 1password-cli

		# Add account and login
		op account add
		eval "$(op signin)"
	fi
else
	log_error "$OS_NAME is not supported!"
	return 0
fi
