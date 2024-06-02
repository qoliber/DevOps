#!/usr/bin/env bash

install_composer() {
  curl -s https://getcomposer.org/installer | php
  mv composer.phar /usr/local/bin/composer
}