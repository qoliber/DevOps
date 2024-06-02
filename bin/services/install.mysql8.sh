#!/usr/bin/env bash

install_mysql8() {
  # install mysql server
  apt install mysql-server-8.0 -y
  if [ ! -f /etc/mysql/conf.d/mysql.cnf.init ]; then # copy init file if it does not exists
      cp "/etc/mysql/conf.d/mysql.cnf" "/etc/mysql/conf.d/mysql.cnf.init"
  fi

  cp "$DIR/../templates/mysql/mysqltuner.pl" "/root/mysqltuner.pl"
  chmod +x "/root/mysqltuner.pl"
}