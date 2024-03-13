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
  echo "Ensure you have a secret created and a 1Password service account token with access to the secret before continuing!"
  echo
  printf -- "Vault: "
  read -r vault
  printf -- "Secret: "
  read -r secret
  printf -- "Token: "
  read -r token
}

if [ "$1" = macos ]; then
  brew_install openconnect
  brew_install vpn-slice

  mkdir -p "$HOME/.vpn"
  touch "$HOME/.vpn/routes"

  if ! cat "$DOTFILES/.local" | grep "VPN_" 2>&1 >/dev/null; then
    get_vpn_config
    printf -- "\nexport VPN_VAULT=\"%s\"\nexport VPN_SECRET=\"%s\"\nexport OP_SERVICE_ACCOUNT_TOKEN=\"%s\"" \
      "$vault" "$secret" "$token" >>"$DOTFILES/.local"
  fi

elif [ "$1" = debian ]; then
  apt_install openconnect

  if [ ! -d "/etc/systemd/system/openconnect.service" ]; then
    get_vpn_config
    cat >openconnect.service <<EOF
[Unit]
Description=OpenConnect service
After=network.target

[Service]
Type=simple
Environment=OP_SERVICE_ACCOUNT_TOKEN=${token}
ExecStart=/etc/openconnect/connect.sh
Restart=always
RestartSec=30

[Install]
WantedBy=multi-user.target
EOF

  cat >connect.sh <<EOF
#!/bin/sh

set -e

username=\$(op read "op://${vault}/${secret}/username")
password=\$(op read "op://${vault}/${secret}/password")
authgroup=\$(op read "op://${vault}/${secret}/authgroup")
website=\$(op read "op://${vault}/${secret}/website")
otp=\$(op item get "${secret}" --otp --vault "${vault}")

printf -- "%s\n%s\n" "\$password" "\$otp" \\
  | openconnect --user="\$username" \\
    --authgroup="\$authgroup" \\
    --script=/usr/share/vpnc-scripts/vpnc-script-fix \\
    --csd-wrapper=/usr/libexec/openconnect/csd-post.sh \\
    --os=linux-64 "\$website" \\
    --non-inter \\
    --passwd-on-stdin
EOF
    $maybe_sudo mv openconnect.service /etc/systemd/system/openconnect.service
    $maybe_sudo mkdir -p /etc/openconnect
    $maybe_sudo mv connect.sh /etc/openconnect/connect.sh
    $maybe_sudo chmod +x /etc/openconnect/connect.sh
    curl -fsSLO https://gitlab.com/openconnect/vpnc-scripts/-/raw/master/vpnc-script
    $maybe_sudo chmod +x vpnc-script
    $maybe_sudo mv vpnc-script /usr/share/vpnc-scripts/vpnc-script-fix
    $maybe_sudo systemctl daemon-reload
    $maybe_sudo systemctl start openconnect
  fi
else
  type openconnect >/dev/null || {
    log_error "$1 is not supported!"
    return 0
  }
fi
