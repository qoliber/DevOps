#!/usr/bin/env bash

install_certbot() {
  # install snapd
  sudo apt install snapd

  # certbot installation
  sudo snap install core
  sudo snap refresh core
  sudo snap install --classic certbot
  sudo ln -fns /snap/bin/certbot /usr/bin/certbot
  sudo ln -fns /snap/bin/certbot /usr/local/bin/certbot

  sudo snap set certbot trust-plugin-with-root=ok
  sudo snap install certbot-dns-cloudflare
}