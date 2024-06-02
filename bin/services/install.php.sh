#!/usr/bin/env bash

install_php() {
  LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php --yes
  apt update

  i=0
  while read line
  do
      phpVersions[ ${i} ]="$line"
      (( i++ ))
  done < <(ls "${DIR}/../templates/php")


  for phpVersion in PHP_VERSIONS
  do
    apt install -y "${phpVersion}" \
      "${phpVersion}-bcmath" "${phpVersion}-cgi" "${phpVersion}-cli" "${phpVersion}-common" "${phpVersion}-curl" \
      "${phpVersion}-dev" "${phpVersion}-fpm" "${phpVersion}-gd" "${phpVersion}-imap" "${phpVersion}-intl" \
      "${phpVersion}-xml" \
      "${phpVersion}-mbstring"  "${phpVersion}-mysql" \
      "${phpVersion}-oauth" "${phpVersion}-opcache" "${phpVersion}-pgsql" "${phpVersion}-soap" \
      "${phpVersion}-sqlite3" "${phpVersion}-xml" "${phpVersion}-xsl" "${phpVersion}-zip" "${phpVersion}-mcrypt" "${phpVersion}-xmlrpc"

      # shellcheck disable=SC2072
      if [ "${i}" \> "5.6" ] && [ "${i}" \< "8.0" ]
      then
        apt install -y "${phpVersion}-json" "${phpVersion}-xmlrpc"
      fi

    cp "${DIR}/../templates/php/${i}/cli/php.ini" "/etc/php/${i}/cli/php.ini"
    cp "${DIR}/../templates/php/${i}/fpm/php.ini" "/etc/php/${i}/fpm/php.ini"

    systemctl restart "${phpVersion}-fpm"
  done

  # install imagick
  apt install -y php-imagick
}