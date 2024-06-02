#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# echo "SSHUSER=$SSHUSER"
# echo "DOMAIN=$DOMAIN"
# echo "PHP_VERSION=$PHP_VERSION"
# echo "HTTP_SERVER=$HTTP_SERVER"
# echo "CLOUD_FLARE_API_TOKEN=$CLOUD_FLARE_API_TOKEN"
# echo "PHP_USE_MAILHOG=$PHP_USE_MAILHOG"
# echo "PHP_OPCACHE=$PHP_OPCACHE"


# form wizard for installation
source $DIR/../wizard/domain.wizard.sh
source $DIR/functions/extract.version.sh

source $DIR/functions/prepare.apache.http.server.sh
source $DIR/functions/prepare.certbot.certificate.sh
source $DIR/functions/prepare.mysql.user.sh
source $DIR/functions/prepare.nginx.http.server.sh
source $DIR/functions/prepare.php.pool.sh
source $DIR/functions/prepare.unix.user.sh

domain_wizard

# initiate domain configuration wizard
case $result in
    1|255) # Cancel/Exit pressed
        clear
        echo "Process exited."
        exit
        ;;
esac

# extract PHP version and set upstream name
PHP_VERSION=$(extract_version "$PHP_VERSION")
UPSTREAM_NAME=$(echo "$SSHUSER-$DOMAIN-php$PHP_VERSION" | sed 's/[^a-zA-Z0-9\.-]//g')


prepare_unix_user             "$SSHUSER"        "$DOMAIN"
prepare_php_upstream          "$PHP_VERSION"    "$UPSTREAM_NAME"    "$SSHUSER"
prepare_php_fpm_pool          "$PHP_VERSION"    "$UPSTREAM_NAME"    "$SSHUSER"  "$PHP_OPCACHE"  "$PHP_USE_MAILHOG"
prepare_certbot_certificate   "$CLOUD_FLARE_API_TOKEN"  "$DOMAIN"
prepare_nginx_files           "$SSHUSER"        "$DOMAIN"           "$UPSTREAM_NAME"
prepare_mysql_user            "$SSHUSER"        "$DOMAIN"


# install http server
  if [ "$HTTPSERVER" = "apache" ]; then
    apt install -y apache2
    a2enmod rewrite proxy headers ssl vhost_alias proxy_fcgi proxy_balancer proxy_http proxy_wstunnel
    cp "$DIR/../templates/apache2/ports.conf" "/etc/apache2/ports.conf"
  elif [ "$HTTPSERVER" = "nginx" ]; then
    apt install -y nginx
  fi


# magento2 / varnish files
if [ "$FRAMEWORK" = "magento2" ]; then
  apt install -y varnish
  cp "$DIR/../config/staging/$FRAMEWORK/etc/varnish/default.vcl" "/etc/varnish/default.vcl"
  cp "$DIR/../config/staging/$FRAMEWORK/etc/default/varnish" "/etc/varnish"
  systemctl restart varnish
fi


# create CERTIFICATE FILE
# certbot commands
i=0
for word in $DOMAINS
do
  ((i++))
  CERTBOTDOMAINLIST[i]="$word"
done


# obtain CERTS

# create SSLs, only files
for DOMAIN in "${CERTBOTDOMAINLIST[@]}"
do
   :
    echo "$DOMAIN configuration..."
    PHP_FPM_PROCESS="${DOMAIN//./}" # set php-fpm process name for unique logs

    cp "$DIR/../config/staging/magento2/etc/php/fpm/pool/default" "/etc/php/$PHP_VERSION/fpm/pool.d/$SSHUSER-$PHP_FPM_PROCESS.conf"
    sed -i "s/{{user}}/$SSHUSER/" "/etc/php/$PHP_VERSION/fpm/pool.d/$SSHUSER-$PHP_FPM_PROCESS.conf"
    sed -i "s/{{fastcgi_user}}/$SSHUSER-$PHP_FPM_PROCESS/" "/etc/php/$PHP_VERSION/fpm/pool.d/$SSHUSER-$PHP_FPM_PROCESS.conf"
    sed -i "s/{{php_version}}/$PHP_VERSION/" "/etc/php/$PHP_VERSION/fpm/pool.d/$SSHUSER-$PHP_FPM_PROCESS.conf"

    certbot certonly --agree-tos -m setup@qsolutionsstudio.com --non-interactive --dns-cloudflare --dns-cloudflare-credentials ~/.secret/cloudflare.ini --dns-cloudflare-propagation-seconds 60 -d "$DOMAIN"

    # install http server
    if [ "$HTTPSERVER" = "apache" ]; then
      echo "apache2"
    elif [ "$HTTPSERVER" = "nginx" ]; then
      cp "$DIR/../config/staging/$FRAMEWORK/etc/$HTTPSERVER/nginx.conf" "/etc/$HTTPSERVER/sites-available/$DOMAIN.conf"

      sed -i "s/{{user}}/$SSHUSER/" "/etc/$HTTPSERVER/sites-available/$DOMAIN.conf"
      sed -i "s/{{fastcgi_user}}/$SSHUSER-$PHP_FPM_PROCESS/" "/etc/$HTTPSERVER/sites-available/$DOMAIN.conf"
      sed -i "s/{{php_version}}/$PHP_VERSION/" "/etc/$HTTPSERVER/sites-available/$DOMAIN.conf"
      sed -i "s/{{domain}}/$DOMAIN/" "/etc/$HTTPSERVER/sites-available/$DOMAIN.conf"
      sed -i "s/{{MAGE_RUN_CODE}}/$RUNCODE/" "/etc/$HTTPSERVER/sites-available/$DOMAIN.conf"
      ln -sfn "/etc/$HTTPSERVER/sites-available/$DOMAIN.conf" "/etc/$HTTPSERVER/sites-enabled/$DOMAIN.conf"

      # copy hostmap to project
      if [ -f "$DIR/../config/staging/$FRAMEWORK/etc/$HTTPSERVER/hostmap/$SSHUSER" ]; then
        cp "$DIR/../config/staging/$FRAMEWORK/etc/$HTTPSERVER/hostmap/$SSHUSER" "/home/$SSHUSER/host.map.conf"
      fi

      # hostmap [nginx] conf file needs to be created per server if there is domain mapping
      if [ -f "/home/$SSHUSER/host.map.conf" ]; then
        cat "/home/$SSHUSER/host.map.conf" "/etc/$HTTPSERVER/sites-available/$DOMAIN.conf" > "/etc/$HTTPSERVER/sites-available/$DOMAIN.conf.tmp"
        mv "/etc/$HTTPSERVER/sites-available/$DOMAIN.conf.tmp" "/etc/$HTTPSERVER/sites-available/$DOMAIN.conf"
      fi
      ########################### WARNING: make sure RUN_CODE is the same as passed variable ###############################

      # magento 2 default template file
      cp "$DIR/../config/staging/$FRAMEWORK/etc/$HTTPSERVER/magento2.conf" "/home/$SSHUSER/$DOMAIN-m2.conf"
      sed -i "s/{{fastcgi_user}}/$SSHUSER-$PHP_FPM_PROCESS/" "/home/$SSHUSER/$DOMAIN-m2.conf"
      sed -i "s/{{MAGE_RUN_CODE}}/$RUNCODE/" "/home/$SSHUSER/$DOMAIN-m2.conf"
    fi
done


rm cachetool.phar
wget https://github.com/gordalina/cachetool/releases/download/9.1.0/cachetool.phar
mv cachetool.phar "/home/$SSHUSER/cachetool.phar"
chown -R "$SSHUSER:$SSHUSER" "/home/$SSHUSER/cachetool.phar"

systemctl restart nginx
systemctl restart "php$PHP_VERSION-fpm"
