#!/bin/sh

# When using gpg with ssh modules, ensure that the ssh module loads first and
# the sudo alias will be set with the forwarded SSH_AUTH_SOCK instead of the one
# set by gpg
#
# shellcheck disable=SC2139
alias sudo="SSH_AUTH_SOCK=$ORIGINAL_SSH_AUTH_SOCK sudo"
