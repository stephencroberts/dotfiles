#!/bin/sh

type asdf >/dev/null || {
  log_error "Please install the asdf module!"
  return 0
}

########
# just #
########

asdf plugin list | grep just >/dev/null || asdf plugin-add just
asdf install just latest
asdf global just latest

######################
# GNU Global + ctags #
######################

if [ "$1" = debian ]; then
  apt_install inotify-tools

  # Use ctags as backend for global
  snap_install universal-ctags

  # Install GNU Global dependencies
  # https://www.gnu.org/software/global/download.html
  apt_install automake
  apt_install autoconf
  apt_install gperf
  apt_install bison
  apt_install flex
elif [ "$1" = macos ]; then
  brew_install universal-ctags
else
  if ! type ctags >/dev/null && ctags --version | grep "Universal Ctags" 2>&1 /dev/null; then
    log_error "$1 is not supported!"
    return 0
  fi
fi

# Install GNU Global from source
if ! type global >/dev/null; then
  log_header "Installing GNU Global"
  curl -fSs -o global.tar.gz https://ftp.gnu.org/pub/gnu/global/global-6.6.12.tar.gz
  tar -zxf global.tar.gz
  rm global.tar.gz
  wd=$(pwd)
  cd global-* || {
    log_error "Failed to change directory to global"
    return 1
  }
  ./configure --with-universal-ctags="$(which ctags)"
  make
  sudo make install
  cp -- *.vim "$DOTFILES/modules/dev-tools/"
  cd "$wd" || {
    log_error "Failed to change directory from global to working directory!"
    return 1
  }
  rm -rf global-*
fi

# Install git hooks
# TODO: may need to make sure there are no collisions with other modules that
# use git hooks, but there aren't any currently
mkdir -p "$HOME/.git_template/hooks"
link_file "$DOTFILES/modules/dev-tools/git/gtags" "$HOME/.git_template/hooks/gtags"
link_file "$DOTFILES/modules/dev-tools/git/post-checkout" "$HOME/.git_template/hooks/post-checkout"
link_file "$DOTFILES/modules/dev-tools/git/post-commit" "$HOME/.git_template/hooks/post-commit"
link_file "$DOTFILES/modules/dev-tools/git/post-merge" "$HOME/.git_template/hooks/post-merge"
link_file "$DOTFILES/modules/dev-tools/git/post-rewrite" "$HOME/.git_template/hooks/post-rewrite"

##########
# Vivify #
##########

if [ "$1" = macos ]; then
  brew_install jannis-baum/tap/vivify
fi
