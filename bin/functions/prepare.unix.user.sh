#!/usr/bin/env bash

prepare_unix_user() {
  local SSHUSER="$1"
  local DOMAIN="$2"
  local USER_FILES=(".bash_profile", ".profile")
  local FOLDERS_USER=(".ssh" "logs" "docker" "$DOMAIN")
  local FOLDERS_DOMAIN=("backup" "logs" "release" "public_html" "public_html/pub" "shared")

  # create SSH USER
  randomStr="$(xxd -l16 -ps /dev/urandom)" # password

  # create password, just random one, login only by SSH keys
  password="$(openssl passwd -1  -salt "$randomStr" "$SSHUSER")"

  # create user and create apache2 + domain + php related configuration
  if id -u "$SSHUSER" >/dev/null 2>&1; then
    echo "User already exists, skipping creation..."
  else
    # add user
    useradd "$SSHUSER"
    usermod --password "$password" "$SSHUSER"
    usermod --shell /bin/bash "$SSHUSER"
  fi


  # create user directories
  if [ ! -d "/home/$SSHUSER" ]
  then
    mkdir "/home/$SSHUSER"
    # setup default bash files for shell usage
  fi


  # prepare default bash profile
  [ ! -f "/home/$SSHUSER/.bashrc" ]  && cp "$DIR/../templates/bash/.bashrc" "/home/$SSHUSER/.bashrc"
  [ ! -f "/home/$SSHUSER/.profile" ] && cp "$DIR/../templates/bash/.bashrc" "/home/$SSHUSER/.bashrc"


  # prepare main folders for the user
  for FOLDER in "${FOLDERS_USER[@]}"; do
    if [ ! -d "/home/$SSHUSER/$FOLDER" ]; then
      mkdir -p "/home/$SSHUSER/$FOLDER"
    fi
  done


  # prepare domain folder
  for FOLDER in "${FOLDERS_DOMAIN[@]}"; do
    if [ ! -d "/home/$SSHUSER/$DOMAIN/$FOLDER" ]; then
      mkdir -p "/home/$SSHUSER/$DOMAIN/$FOLDER"
    fi
  done


  # create set of SSH keys
  if [ ! -f "/home/$SSHUSER/.ssh/id_rsa" ]
  then
    ssh-keygen -t rsa -N "" -f "/home/$SSHUSER/.ssh/id_rsa"
  fi


  # adding known hosts
  if ! grep -q bitbucket.org "/home/$SSHUSER/.ssh/known_hosts"; then
      ssh-keyscan bitbucket.org >> "/home/$SSHUSER/.ssh/known_hosts"
  fi

  if ! grep -q github.com "/home/$SSHUSER/.ssh/known_hosts"; then
      ssh-keyscan github.com >> "/home/$SSHUSER/.ssh/known_hosts"
  fi


  # final step, add to groups and set privileges
  sudo usermod -aG crontab "$SSHUSER"
  sudo usermod -aG docker  "$SSHUSER"
  chown "$SSHUSER:$SSHUSER" -R "/home/$SSHUSER/"

    # add user to sudoers, if needed
  if ! grep -q "$SSHUSER" "/etc/sudoers"; then
    echo "$SSHUSER ALL=(ALL) NOPASSWD: /bin/systemctl restart nginx, /bin/systemctl reload nginx" > "/etc/sudoers"
    echo "$SSHUSER ALL=(ALL) NOPASSWD: /bin/systemctl restart php5.6-fpm, /bin/systemctl restart php7.0-fpm, /bin/systemctl restart php7.1-fpm, /bin/systemctl restart php7.2-fpm, /bin/systemctl restart php7.3-fpm, /bin/systemctl restart php7.4-fpm, /bin/systemctl restart php8.0-fpm, /bin/systemctl restart php8.1-fpm, /bin/systemctl restart php8.2-fpm, /bin/systemctl restart php8.3-fpm" > "/etc/sudoers"
    echo "$SSHUSER ALL=(ALL) NOPASSWD: /bin/systemctl reload php5.6-fpm, /bin/systemctl reload php7.0-fpm, /bin/systemctl reload php7.1-fpm, /bin/systemctl reload php7.2-fpm, /bin/systemctl reload php7.3-fpm, /bin/systemctl reload php7.4-fpm, /bin/systemctl reload php8.0-fpm, /bin/systemctl reload php8.1-fpm, /bin/systemctl reload php8.2-fpm, /bin/systemctl reload php8.3-fpm" > "/etc/sudoers"
    echo "$SSHUSER ALL=(ALL) NOPASSWD: /bin/systemctl restart mysql.service, /bin/systemctl reload mysql.service" > "/etc/sudoers"
    echo "$SSHUSER ALL=(ALL) NOPASSWD: /bin/systemctl start redis-server, /bin/systemctl stop redis-server, /bin/systemctl restart redis-server, /bin/systemctl reload redis-server" > "/etc/sudoers"
  fi

}
