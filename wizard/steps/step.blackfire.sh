#!/usr/bin/env bash

install_blackfire() {
  # First dialog: Radio button to install Blackfire
  cmd=(dialog --extra-button --extra-label "Previous" --radiolist "Do you want to install Blackfire?" 9 60 2)

  options=(
    "Yes" "" on
    "No" "" off
  )

  installBlackfire=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
  local result=$?

  case $result in
    0)  # OK button
      if [[ $installBlackfire == "Yes" ]]; then
        # Second dialog: Form to paste Blackfire credentials
        while true; do
          HEIGHT=20
          WIDTH=80
          TITLE="Blackfire Credentials"
          FORM_TEXT="Please enter your Blackfire credentials:"

          form_output=$(dialog --title "$TITLE" --no-cancel --form "$FORM_TEXT" 11 $WIDTH 4 \
              "BLACKFIRE_CLIENT_ID:" 1 1 "${BLACKFIRE_CLIENT_ID}" 1 30 44 3 \
              "BLACKFIRE_CLIENT_TOKEN:" 2 1 "${BLACKFIRE_CLIENT_TOKEN}" 2 30 44 0 \
              "BLACKFIRE_SERVER_ID:" 3 1 "${BLACKFIRE_SERVER_ID}" 3 30 44 0 \
              "BLACKFIRE_SERVER_TOKEN:" 4 1 "${BLACKFIRE_SERVER_TOKEN}" 4 30 44 0 2>&1 >/dev/tty)

          IFS=$'\n' read -r -d '' -a credentials <<< "$form_output"

          # Display the entered credentials
          BLACKFIRE_CLIENT_ID="${credentials[0]}"
          BLACKFIRE_CLIENT_TOKEN="${credentials[1]}"
          BLACKFIRE_SERVER_ID="${credentials[2]}"
          BLACKFIRE_SERVER_TOKEN="${credentials[3]}"

          if [[ -z "$BLACKFIRE_CLIENT_ID" || -z "$BLACKFIRE_CLIENT_TOKEN" || -z "$BLACKFIRE_SERVER_ID" || -z "$BLACKFIRE_SERVER_TOKEN" ]]; then
            dialog --msgbox "All fields are required. Please fill in all credentials." 10 50
            clear
          else
            break
          fi
        done
      fi
      ;;
  esac

  return $result
}