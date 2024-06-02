#!/usr/bin/env bash
#SSHUSER - global domain

dialog_username() {
  dialog \
    --title "Step $step - User name" \
    --inputbox "Please enter user name (UNIX user):" 8 40 2>user.txt

    local result=$?
    SSHUSER=$(<user.txt)
    rm user.txt

    return $result
}