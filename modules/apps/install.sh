#!/bin/sh

if [ "$1" = macos ]; then
	brew_install 1password
	brew_install 1password-cli
	# mas is a cli for the App Store
	# https://github.com/mas-cli/mas
	brew_install mas
	brew_cask_install arc
	brew_cask_install elgato-control-center
	brew_cask_install microsoft-teams
	brew_cask_install postman
	brew_cask_install utm
	brew_cask_install visual-studio-code

	mas list | grep "1Password for Safari" >/dev/null || mas install 1569813296
	mas list | grep "MeetingBar" >/dev/null || mas install 1532419400
	mas list | grep "Microsoft Outlook" >/dev/null || mas install 985367838
	mas list | grep "Slack" >/dev/null || mas install 803453959

	if ! brew list --cask iterm2 >/dev/null; then
		brew_cask_install iterm2

		# Specify the preferences directory
		defaults write com.googlecode.iterm2.plist PrefsCustomFolder \
			-string "~/.iterm2"
		# Tell iTerm2 to use the custom preferences in the directory
		defaults write com.googlecode.iterm2.plist LoadPrefsFromCustomFolder \
			-bool true
	fi

	link_file "$DOTFILES/modules/apps/.iterm2"
elif [ "$1" = debian ]; then
	# if ! type 1password >/dev/null; then
	#   # sudo apt --fix-broken install?
	#   apt_install gnupg2
	#   curl -O https://downloads.1password.com/linux/debian/amd64/stable/1password-latest.deb
	#   $maybe_sudo dpkg -i 1password-latest.deb
	#   rm 1password-latest.deb
	# fi

	if ! type op >/dev/null; then
		# Install 1password-cli
		# https://developer.1password.com/docs/cli/get-started/
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
		eval $(op signin)
	fi
else
	log_error "$1 is not supported!"
	return 0
fi
