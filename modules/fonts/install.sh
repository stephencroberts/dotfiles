# https://github.com/tonsky/FiraCode
firacode_dir="$DOTFILES/modules/fonts/firacode"
firacode_zip="$DOTFILES/modules/fonts/firacode.zip"

if [ ! -d "$firacode_dir" ]; then
  url=$(curl --fail --silent --show-error \
    https://api.github.com/repos/tonsky/firacode/releases/latest \
  | grep browser_download_url \
  | cut -d : -f 2,3 \
  | tr -d \" \
  | xargs)

  curl --fail --silent --show-error --location --output "$firacode_zip" "$url"
  unzip -d "$firacode_dir" "$firacode_zip"
fi

if [ "$1" = macos ]; then
  find "$firacode_dir" -name '*.ttf' -exec cp {} "$HOME/Library/Fonts" \;
fi
