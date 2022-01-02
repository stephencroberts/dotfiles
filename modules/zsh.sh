if [ ! -e "${ZDOTDIR:-$HOME}/.zprezto" ]; then
  git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
fi

# TODO: Move config files to dotfiles and symlink
for rcfile in $(ls "${ZDOTDIR:-$HOME}"/.zprezto/runcoms | grep -v README.md); do
  # link_file "${ZDOTDIR:-$HOME}/.zprezto/runcoms/$rcfile"
  ln -sf "${ZDOTDIR:-$HOME}/.zprezto/runcoms/$rcfile" "${ZDOTDIR:-$HOME}/.$rcfile"
done
