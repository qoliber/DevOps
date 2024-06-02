#!/usr/bin/env bash
# UBUNTU / DEBIAN SERVER CONFIGURE

source $DIR./bin/services/install.blackfire.sh
source $DIR./bin/services/install.certbot.sh
source $DIR./bin/services/install.composer.sh
source $DIR./bin/services/install.docker.sh
source $DIR./bin/services/install.http-server.sh
source $DIR./bin/services/install.mailhog.sh
source $DIR./bin/services/install.mysql8.sh
source $DIR./bin/services/install.node.sh
source $DIR./bin/services/install.php.sh


# install all required libs for server
sudo apt autoremove -y
sudo apt-get update -y
sudo apt-get install \
  autoconf \
  bison \
  build-essential \
  ca-certificates \
  curl \
  dialog \
  git \
  gnupg \
  htop \
  jq \
  libssl-dev \
  libreadline-dev \
  libyaml-dev \
  libreadline-dev \
  libncurses5-dev \
  libffi-dev \
  libgdbm-dev \
  lsb-release \
  mc \
  opendkim \
  opendkim-tools \
  software-properties-common \
  python3-pip \
  python3-setuptools \
  zlib1g-dev \
  pv -y

# init main directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

install_docker_engine

install_php
install_blackfire

install_mysql8
install_composer
install_nodejs
install_certbot

install_http_server
install_mailhog

exit;

# install apache for development
# apt install -y apache2
# a2enmod rewrite proxy headers ssl vhost_alias proxy_fcgi proxy_balancer proxy_http proxy_wstunnel http2
# cp "$DIR/../templates/apache2/ports.conf" "/etc/apache2/ports.conf"
# systemctl restart apache2
# systemctl stop apache2

# PHP PHALCON
# curl -s https://packagecloud.io/install/repositories/phalcon/stable/script.deb.sh | sudo bash
# cd ~ && git clone https://github.com/phalcon/phalcon-devtools.git && cd phalcon-devtools
# ln -s $(pwd)/phalcon /usr/bin/phalcon
# chmod ugo+x /usr/bin/phalcon





# install ruby
apt install -y ruby-full
# - install mina -
gem install mina:0.3.6


# install redis tools
apt install redis-server redis-tools -y

# update python
apt-get install  -y



# change cron settings
sudo chown -R root:crontab /usr/bin/crontab
sudo chmod 2755 /usr/bin/crontab

# for password generation
apt install apache2-utils

# for elasticsearch
sudo sysctl -w vm.max_map_count=262144