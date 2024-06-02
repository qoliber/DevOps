#!/usr/bin/env bash

# Present the radiolist dialog to the user
dialog_opcache() {
  # Initialize options as off
  local OPCACHE_ENABLED="off"
  local OPCACHE_DISABLED="off"

  # Set the correct option to "on" based on MYSQL_SERVER
  if [ "$PHP_OPCACHE" = "Enabled" ]; then
      OPCACHE_ENABLED="on"
  elif [ "$PHP_OPCACHE" = "Disabled" ]; then
      OPCACHE_DISABLED="on"
  fi

  dialog \
    --title "Step $step - Enable Opcache" \
    --extra-button --extra-label "Previous" \
    --ok-label "Next" \
    --cancel-label "Exit" \
    --radiolist "" 10 60 4 \
  "Yes" "" $OPCACHE_ENABLED \
  "No" "" $OPCACHE_DISABLED 2>opcache.txt

  local result=$?
  PHP_OPCACHE=$(<opcache.txt)

  rm opcache.txt

  return $result
}