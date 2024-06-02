#!/usr/bin/env bash

prepare_mysql_user() {
  local USER="$1"
  local DOMAIN="$2"

  local RANDOMSTRING="$(xxd -l16 -ps /dev/urandom)"
  local MYSQL_USER=$(echo "$USER-$(echo "$DOMAIN" | sed 's/[^a-zA-Z0-9]//g')" | tr '[:upper:]' '[:lower:]')
  local MYSQL_DATABASE="$MYSQL_USER"
  local MYSQL_PASSWORD=$(< /dev/urandom tr -dc A-Za-z0-9 | head -c 16)

  mysql -e "CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE\`;"

  mysql -e "DROP USER IF EXISTS \`$MYSQL_USER\`@'localhost';";
  mysql -e "DROP USER IF EXISTS \`$MYSQL_USER\`@'%';";

  mysql -e "CREATE USER \`$MYSQL_USER\`@'localhost' IDENTIFIED BY '$MYSQL_PASSWORD';"
  mysql -e "GRANT ALL PRIVILEGES ON  \`$MYSQL_DATABASE\`.* TO '$MYSQL_USER'@'localhost' WITH GRANT OPTION;"

  mysql -e "CREATE USER \`$MYSQL_USER\`@'%' IDENTIFIED BY '$MYSQL_PASSWORD';"
  mysql -e "GRANT ALL PRIVILEGES ON  \`$MYSQL_DATABASE\`.* TO \`$MYSQL_USER\`@'%' WITH GRANT OPTION;"

  mysql -e "FLUSH PRIVILEGES;"

  echo "[client]" >  "/home/$USER/$DOMAIN/.my.cnf"
  echo "user=$MYSQL_USER" >> "/home/$USER/$DOMAIN/.my.cnf"
  echo "password=$MYSQL_PASSWORD" >> "/home/$USER/$DOMAIN/.my.cnf"
}