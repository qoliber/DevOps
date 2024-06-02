#!/usr/bin/env bash

# Present the radiolist dialog to the user
install_http_server() {
    if [ "$HTTP_SERVER" = "apache" ]; then
      apt install -y apache2
      a2enmod rewrite proxy headers ssl vhost_alias proxy_fcgi proxy_balancer proxy_http proxy_wstunnel
      cp "$DIR/../templates/apache2/ports.conf" "/etc/apache2/ports.conf"
    elif [ "$HTTP_SERVER" = "nginx" ]; then
      apt install -y nginx
    fi
}