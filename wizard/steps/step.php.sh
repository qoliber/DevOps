#!/usr/bin/env bash

# Present the radiolist dialog to the user
select_php_version() {
  local PHP72_OPTION="off"
  local PHP73_OPTION="off"
  local PHP74_OPTION="off"
  local PHP80_OPTION="off"
  local PHP81_OPTION="off"
  local PHP82_OPTION="off"
  local PHP83_OPTION="on"

  options=(
    "php7.2" "" $PHP72_OPTION
    "php7.3" "" $PHP73_OPTION
    "php7.4" "" $PHP74_OPTION
    "php8.0" "" $PHP80_OPTION
    "php8.1" "" $PHP81_OPTION
    "php8.2" "" $PHP82_OPTION
    "php8.3" "" $PHP83_OPTION
  )

  cmd=(dialog --separate-output --checklist "Select which PHP versions to install:" 14 76 16)
  PHP_VERSIONS=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
  local result=$?

  return $result
}