if [ "$1" = macos ]; then
  brew list vim >/dev/null || brew install vim
elif [ "$1" = ubuntu ]; then
  sudo apt-get -qq install vim
elif [ "$1" = alpine ]; then
  type vim >/dev/null || apk add vim
else
  log_error "$1 is not supported!"
fi

link_file "$DOTFILES/modules/vim/.vimrc"

# Install vim-plug if needed
[ -e ~/.vim/autoload/plug.vim ] || curl --fail --silent --show-error --location\
  --output ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Install vim plugins
vim +PlugInstall +qall
