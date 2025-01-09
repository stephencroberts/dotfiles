#!/bin/sh

if [ "$1" = macos ]; then
  brew_install colima
  brew services start colima
  brew_install docker
  brew_install docker-compose
elif [ "$1" = debian ]; then
  # https://docs.docker.com/engine/install/ubuntu/
  for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do
    apt_remove "$pkg"
  done

  if [ ! -e /etc/apt/keyrings/docker.asc ]; then
    # Add Docker's official GPG key:
    apt_install ca-certificates
    $maybe_sudo install -m 0755 -d /etc/apt/keyrings
    $maybe_sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    $maybe_sudo chmod a+r /etc/apt/keyrings/docker.asc

    # Add the repository to Apt sources:
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
      $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
      $maybe_sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    $maybe_sudo apt-get update
  fi

  for pkg in docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin; do
    apt_install "$pkg"
  done

  getent group | grep "^docker:" 2>&1 >/dev/null || $maybe_sudo groupadd docker
  groups "$USER" | grep docker 2>&1 >/dev/null \
    || $maybe_sudo usermod -aG docker "$USER"

  apt_install docker-compose-plugin
else
  type docker >/dev/null || {
    log_error "$1 is not supported!"
    return 0
  }
fi
