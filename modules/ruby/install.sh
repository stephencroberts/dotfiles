#!/bin/sh

type asdf >/dev/null || {
	log_error "Please install the asdf module!"
	return 0
}

# TODO: install ruby
