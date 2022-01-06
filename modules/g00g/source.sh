# Ensure gcloud is in the PATH
[ -d /usr/local/google-cloud-sdk ] \
  && ! echo "$PATH" | grep '/usr/local/google-cloud-sdk/bin' >/dev/null 2>&1 \
  && export PATH="/usr/local/google-cloud-sdk/bin:$PATH"

## Auto-completion

if [ -d /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk ]; then
  gsdk_dir=/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk
elif [ -d /usr/local/google-cloud-sdk ]; then
  gsdk_dir=/usr/local/google-cloud-sdk
fi

[ -n "$BASH_VERSION" ] \
  && [ -e "$gsdk_dir/completion.bash.inc" ] \
  && . "$gsdk_dir/completion.bash.inc"

[ -n "$ZSH_VERSION" ] \
  && [ -e "$gsdk_dir/completion.zsh.inc" ] \
  && . "$gsdk_dir/completion.zsh.inc"
