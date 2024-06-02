#!/usr/bin/env bash
# config
sudo ldconfig /lib/x86_64-linux-gnu/

certbot_get_certificate() {
  # $1 - domain address
  # $2 - email address
  /snap/bin/certbot --non-interactive --server https://acme-v02.api.letsencrypt.org/directory \
  -d "$1" certonly \
  --agree-tos \
  --email "$2" \
  --dns-cloudflare \
  --dns-cloudflare-credentials ~/cloudflare.ini \
  --dns-cloudflare-propagation-seconds 60
}