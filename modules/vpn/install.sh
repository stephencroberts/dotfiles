#!/bin/sh

if [ "$1" = debian ]; then
  apt_install openconnect
else
  type openconnect >/dev/null || {
    log_error "$1 is not supported!"
    return 0
  }
fi
