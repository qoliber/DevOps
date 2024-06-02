#!/usr/bin/env bash
#SSHUSER - global domain

dialog_domain() {
  dialog \
    --title "Step $step - Domain" \
    --inputbox "Enter full domain name (including www):" 8 75 2>domain.txt

    local result=$?
    DOMAIN=$(<domain.txt)
    rm domain.txt

    return $result
}