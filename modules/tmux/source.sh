#!/bin/sh

tmux_new_session() {
	tmux new-session -s "$1"
}

tmux_attach() {
	tmux attach -t "$1"
}

alias ta="tmux_attach"
alias ts="tmux_new_session"
alias tl="tmux list-sessions"
