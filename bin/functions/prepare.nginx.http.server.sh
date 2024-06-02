#!/usr/bin/env bash

prepare_php_upstream() {
  local PHP_VERSION="$1"
  local UPSTREAM_NAME="$2"
  local DOMAIN="$3"

  cp "$DIR/../templates/nginx/conf.d/upstream.template.conf" "/etc/nginx/conf.d/$UPSTREAM_NAME.conf"

# update settings
  sed -i "s/{{upstream}}/$UPSTREAM_NAME/" "/etc/nginx/conf.d/$UPSTREAM_NAME.conf"
}

prepare_nginx_files() {
  local USER="$1"
  local DOMAIN="$2"
  local UPSTREAM="$3"

  local CERTIFICATE=$(echo "$DOMAIN" | awk -F '.' '{if (NF>2) print $(NF-2)"."$(NF-1)"."$NF; else print $0;}')

  # configure nginx file
  cp "$DIR/../templates/nginx/sites-available/nginx.conf" "/etc/nginx/sites-available/$DOMAIN.conf"

  sed -i "s/{{user}}/$USER/" "/etc/nginx/sites-available/$DOMAIN.conf"
  sed -i "s/{{domain}}/$DOMAIN/" "/etc/nginx/sites-available/$DOMAIN.conf"
  sed -i "s/{{certificate}}/$CERTIFICATE/" "/etc/nginx/sites-available/$DOMAIN.conf"
  sed -i "s/{{varnish_port}}/6081/" "/etc/nginx/sites-available/$DOMAIN.conf"

  ln -sfn "/etc/nginx/sites-available/$DOMAIN.conf" "/etc/nginx/sites-enabled/$DOMAIN.conf"

  # configure magento2 template
  cp "$DIR/../templates/nginx/sites-available/m2.conf" "/home/$USER/$DOMAIN/magento2.conf"
  sed -i "s/{{upstream}}/$UPSTREAM/" "/home/$USER/$DOMAIN/magento2.conf"
}