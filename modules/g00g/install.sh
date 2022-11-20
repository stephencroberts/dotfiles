#!/bin/sh

# Installs google-cloud-sdk on linux
install_linux() {
  log_header "Finding the latest version of google-cloud-sdk"

  url="https://storage.googleapis.com/storage/v1/b/cloud-sdk-release/o"
  items='[]'
  while [ -n "$url" ]; do

    # List a page of releases
    response=$(curl --fail --location --silent --show-error "$url")

    # Accumulate a list of all linux-x86_64 releases
    items=$(echo "$items$response" \
      | jq -s '.[0] + (
          .[1].items
          | map(.mediaLink))
          | map(select(. | contains("linux-x86_64")))')

    # Configure the next page url
    page_token=$(echo "$response" | jq -r .nextPageToken)
    if [ "$page_token" != null ]; then
      url="${url%\?*}?pageToken=$page_token"
    else
      url=
    fi
  done

  # Get the url for the latest version
  url=$(echo "$items" | jq -r 'map({
      url: .,
      version: .
        | capture("(?<version>\\d+)\\.\\d+\\.\\d")
        | .version
        | tonumber
    })
    | sort_by(.version)
    | last
    | .url')

  # Download gcloud sdk and extract to the home directory
  log_header "Downloading $url"
  curl --fail --silent --show-error --location "$url" | tar -zxf - -C /usr/local
}


if [ "$1" = macos ]; then

  brew_install python #thxg00g
  brew_cask_install google-cloud-sdk

elif [ "$1" = alpine ]; then
  apk_add python3 #thxg00g

  [ -d /usr/local/google-cloud-sdk ] || install_linux

elif [ "$1" = debian ]; then
  apt_install python #thxg00g

  [ -d /usr/local/google-cloud-sdk ] || install_linux
fi
