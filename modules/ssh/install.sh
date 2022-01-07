# TODO: Use AWS or GCP Secret Manager to save/fetch keys

mkdir -p "$HOME/.ssh"
link_file "$DOTFILES/modules/ssh/config" "$HOME/.ssh/config"
