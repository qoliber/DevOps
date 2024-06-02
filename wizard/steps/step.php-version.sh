#!/usr/bin/env bash

# Present the radiolist dialog to the user
select_default_php() {
  local PHP72_OPTION="off"
  local PHP73_OPTION="off"
  local PHP74_OPTION="off"
  local PHP80_OPTION="off"
  local PHP81_OPTION="off"
  local PHP82_OPTION="off"
  local PHP83_OPTION="off"

  case $PHP_VERSION in
      "PHP 7.2")
          PHP72_OPTION="on"
          ;;
      "PHP 7.3")
          PHP73_OPTION="on"
          ;;
      "PHP 7.4")
          PHP74_OPTION="on"
          ;;
      "PHP 8.0")
          PHP80_OPTION="on"
          ;;
      "PHP 8.1")
          PHP81_OPTION="on"
          ;;
      "PHP 8.2")
          PHP82_OPTION="on"
          ;;
      "PHP 8.3")
          PHP83_OPTION="on"
          ;;
  esac

  dialog \
    --title "Step $step - Default PHP CLI interpreter" \
    --extra-button --extra-label "Previous" \
    --ok-label "Next" \
    --cancel-label "Exit" \
    --radiolist "" 13 60 4 \
  "PHP 7.2" "" $PHP72_OPTION \
  "PHP 7.3" "" $PHP73_OPTION \
  "PHP 7.4" "" $PHP74_OPTION \
  "PHP 8.0" "" $PHP80_OPTION \
  "PHP 8.1" "" $PHP81_OPTION \
  "PHP 8.2" "" $PHP82_OPTION \
  "PHP 8.3" "" $PHP83_OPTION 2>php.txt

  # Read the selected option from title.txt
  local result=$?
  PHP_VERSION=$(<php.txt)

  rm php.txt

  return $result
}