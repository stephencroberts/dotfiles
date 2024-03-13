# SSH

## Remote Development

When developing on a remote VM, leverage `autossh` with X11 forwarding and
clipboard syncing by adding a `Host` entry in ssh config (see config for
template) and using `autossh -M 0 <user>@<host>` to connect. Don't forget to use
a `tmux` session on the remote!
