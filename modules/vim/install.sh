if [ "$1" = macos ]; then
  brew_install vim
elif [ "$1" = debian ]; then
  apt_install vim
elif [ "$1" = alpine ]; then
  apk_add vim
else
  log_error "$1 is not supported!"
  return 0
fi

link_file "$DOTFILES/modules/vim/.vimrc"

# Install vim-plug if needed
[ -e ~/.vim/autoload/plug.vim ] || curl --fail --silent --show-error --location\
  --output ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Install vim plugins
vim +PlugInstall +qall
