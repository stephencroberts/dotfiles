[ -d /usr/local/google-cloud-sdk ] \
  && ! echo "$PATH" | grep '/usr/local/google-cloud-sdk/bin' >/dev/null 2>&1 \
  && export PATH="/usr/local/google-cloud-sdk/bin:$PATH"
