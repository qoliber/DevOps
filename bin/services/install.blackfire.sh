#!/usr/bin/env bash

install_blackfire_php() {
# blackfire agent
  wget -q -O - https://packages.blackfire.io/gpg.key | sudo dd of=/usr/share/keyrings/blackfire-archive-keyring.asc
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/blackfire-archive-keyring.asc] http://packages.blackfire.io/debian any main" | sudo tee /etc/apt/sources.list.d/blackfire.list
  sudo apt update

  sudo apt install blackfire
  sudo blackfire agent:config --server-id="${BLACKFIRE_SERVER_ID}" --server-token="${BLACKFIRE_SERVER_TOKEN}"

  sudo systemctl restart blackfire-agent
  sudo apt install blackfire-php

  blackfire client:config --client-id="${BLACKFIRE_CLIENT_ID}" --client-token="${BLACKFIRE_CLIENT_TOKEN}"
}