#!/usr/bin/env bash
#SSHUSER - global domain

dialog_cloudflare_api_token() {
  dialog \
    --title "Step $step - Cloud Flare API Token" \
    --insecure \
    --passwordbox "Cloud Flare API Key:" 8 75 2>cf.txt

    local result=$?
    CLOUD_FLARE_API_TOKEN=$(<cf.txt)
    rm cf.txt
}