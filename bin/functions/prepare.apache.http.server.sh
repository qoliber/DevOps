#!/usr/bin/env bash

prepare_apache_files() {
  local USER="$1"
  local DOMAIN="$2"
  local UPSTREAM="$3"

  # configure nginx file
  cp "$DIR/../templates/nginx/sites-available/nginx.conf" "/etc/nginx/sites-available/$DOMAIN.conf"

  sed -i "s/{{user}}/$USER/" "/etc/nginx/sites-available/$DOMAIN.conf"
  sed -i "s/{{domain}}/$DOMAIN/" "/etc/nginx/sites-available/$DOMAIN.conf"
  sed -i "s/{{varnish_port}}/6081/" "/etc/nginx/sites-available/$DOMAIN.conf"

  ln -sfn "/etc/nginx/sites-available/$DOMAIN.conf" "/etc/nginx/sites-enabled/$DOMAIN.conf"

  # configure magento2 template
  cp "$DIR/../templates/nginx/sites-available/m2.conf" "/home/$USER/$DOMAIN/magento2.conf"
  sed -i "s/{{upstream}}/$UPSTREAM/" "/home/$USER/$DOMAIN/magento2.conf"
}