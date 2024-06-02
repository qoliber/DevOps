#!/usr/bin/env bash

# configure PHP
prepare_php_fpm_pool() {
  local PHP_VERSION="$1"
  local FPM_POOL="$2"
  local USER="$3"
  local OPCACHE="$4"
  local USE_MAILHOG="$5"

  cp "$DIR/../templates/php/php.pool.template" "/etc/php/$PHP_VERSION/fpm/pool.d/$FPM_POOL.conf"

  # enable opcache
  if [ "$OPCACHE" = "Yes" ]; then
    cat "$DIR/../templates/php/config/opcache.conf" >> "/etc/php/$PHP_VERSION/fpm/pool.d/$FPM_POOL.conf"
  fi

  # enable mailhog
  if [ "$USE_MAILHOG" = "Yes" ]; then
    cat "$DIR/../templates/php/config/mailhog.conf" >> "/etc/php/$PHP_VERSION/fpm/pool.d/$FPM_POOL.conf"
  fi

  # configure for user
  sed -i "s/{{upstream}}/$FPM_POOL/"  "/etc/php/$PHP_VERSION/fpm/pool.d/$FPM_POOL.conf"
  sed -i "s/{{user}}/$USER/"          "/etc/php/$PHP_VERSION/fpm/pool.d/$FPM_POOL.conf"


  # restart PHP
  sudo systemctl restart "php$PHP_VERSION-fpm"
}