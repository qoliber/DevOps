#!/usr/bin/env bash

# Present the radiolist dialog to the user
select_http_server() {
  # Initialize options as off
  NGINX_OPTION="off"
  APACHE_OPTION="off"

  # Set the correct option to "on" based on MYSQL_SERVER
  if [ "$HTTP_SERVER" = "Nginx" ]; then
      NGINX_OPTION="on"
  elif [ "$HTTP_SERVER" = "Apache2" ]; then
      APACHE_OPTION="on"
  fi

  dialog \
    --title "Step $step - Http Server" \
    --extra-button --extra-label "Previous" \
    --ok-label "Next" \
    --cancel-label "Exit" \
    --radiolist "" 8 60 4 \
  "Nginx" "" $NGINX_OPTION \
  "Apache2" "" $APACHE_OPTION 2>http.txt

  # Read the selected option from title.txt
  local result=$?
  HTTP_SERVER=$(<http.txt)

  # Clean up by removing the temporary file
  rm http.txt

  return $result
}