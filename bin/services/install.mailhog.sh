#!/usr/bin/env bash

install_mailhog() {
  wget https://github.com/mailhog/mhsendmail/releases/download/v0.2.0/mhsendmail_linux_amd64
  sudo chmod +x mhsendmail_linux_amd64
  sudo mv mhsendmail_linux_amd64 /usr/local/bin/mhsendmail
}