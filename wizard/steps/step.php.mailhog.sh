#!/usr/bin/env bash

# Present the radiolist dialog to the user
dialog_mailhog() {
  # Initialize options as off
  local MAILHOG_YES="off"
  local MAILHOG_NO="off"

  # Set the correct option to "on" based on MYSQL_SERVER
  if [ "$PHP_USE_MAILHOG" = "Yes" ]; then
      MAILHOG_YES="on"
  elif [ "$PHP_USE_MAILHOG" = "No" ]; then
      MAILHOG_NO="on"
  fi

  dialog \
    --title "Step $step - Use Mailhog" \
    --extra-button --extra-label "Previous" \
    --ok-label "Next" \
    --cancel-label "Exit" \
    --radiolist "" 10 60 4 \
  "Yes" "" $MAILHOG_YES \
  "No" "" $MAILHOG_NO 2>mailhog.txt

  local result=$?
  PHP_USE_MAILHOG=$(<mailhog.txt)

  rm mailhog.txt

  return $result
}